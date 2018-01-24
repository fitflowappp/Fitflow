//
//  YGForgetPasswordController.m
//  Yoga
//
//  Created by lyj on 2017/12/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGTopAlert.h"
#import "YGStringUtil.h"
#import "YGEmaiTextField.h"
#import "YGNetworkService.h"
#import "UIColor+Extension.h"
#import "YGResetPasswordController.h"
#import "YGForgetPasswordController.h"
@interface YGForgetPasswordController ()<UITextFieldDelegate>
@property (nonatomic,strong) UIButton  *sendEmailBtn;
@property (nonatomic,strong) UILabel   *forgetPasswordTipLabel;
@property (nonatomic,strong) YGEmaiTextField  *emailAccountTf;
@end

@implementation YGForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItem];
    [self setUpSubviews];
    self.navigationItem.title = @"FORGOT PASSWORD";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)setUpSubviews{
    [self addForgetPasswordTipLabel];
    [self addEmailAccountTf];
    [self addSendEmailBtn];
}

-(void)addForgetPasswordTipLabel{
    CGFloat marginY = 16*SCALE;
    CGFloat marginX = (16/375.0)*self.view.frame.size.width;
    CGFloat witdh   = self.view.frame.size.width-marginX*2;
    self.forgetPasswordTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX,marginY,witdh,100)];
    self.forgetPasswordTipLabel.numberOfLines = 0;
    self.forgetPasswordTipLabel.textColor = [UIColor colorWithHexString:@"#7B7B7B"];
    self.forgetPasswordTipLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    self.forgetPasswordTipLabel.text = @"Enter the email address that you signed up with to receive instructions on how to reset your password.";
    [self.forgetPasswordTipLabel sizeToFit];
    self.forgetPasswordTipLabel.frame = CGRectMake(marginX,marginY,witdh,self.forgetPasswordTipLabel.frame.size.height);
    [self.view addSubview:self.forgetPasswordTipLabel];
}

-(void)addEmailAccountTf{
    CGFloat marginX = (16/375.0)*self.view.frame.size.width;
    CGFloat width =  self.view.frame.size.width-marginX*2;
    CGFloat height  = (44/343.0)*width;
    CGFloat marginY = CGRectGetMaxY(self.forgetPasswordTipLabel.frame)+24*SCALE;
    self.emailAccountTf = [[YGEmaiTextField alloc] initWithFrame:CGRectMake(marginX,marginY,width,height)];
    self.emailAccountTf.backgroundColor = [UIColor colorWithHexString:@"#ECECEC" alpha:0.7];
    self.emailAccountTf.textColor = [UIColor colorWithHexString:@"#000000"];
    self.emailAccountTf.layer.masksToBounds = YES;
    self.emailAccountTf.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailAccountTf.layer.cornerRadius = self.emailAccountTf.frame.size.height/2;
    self.emailAccountTf.font  = [UIFont fontWithName:@"Lato-Bold" size:16];
    [self.emailAccountTf addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.emailAccountTf];
    //
    NSMutableAttributedString *placehodler = [[NSMutableAttributedString alloc] initWithString:@"Email"];
    [placehodler addAttributes:@{NSFontAttributeName:self.emailAccountTf.font,
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#CCCCCC"]
                                 } range:NSMakeRange(0,placehodler.length)];
    self.emailAccountTf.attributedPlaceholder = placehodler;
    [self.view addSubview:self.emailAccountTf];
    //
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
}

-(void)addSendEmailBtn{
    CGFloat marginX = (16/375.0)*self.view.frame.size.width;
    CGFloat width =  self.view.frame.size.width-marginX*2;
    CGFloat height  = (44/343.0)*width;
    CGFloat marginY = CGRectGetMaxY(self.emailAccountTf.frame)+24*SCALE;
    self.sendEmailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendEmailBtn.frame = CGRectMake(marginX,marginY,width,height);
    self.sendEmailBtn.layer.masksToBounds = YES;
    self.sendEmailBtn.adjustsImageWhenHighlighted = NO;
    self.sendEmailBtn.layer.cornerRadius = self.sendEmailBtn.frame.size.height/2;
    [self.sendEmailBtn setTitle:@"SEND EMAIL" forState:UIControlStateNormal];
    [self.sendEmailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendEmailBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
    [self.sendEmailBtn setBackgroundImage:[UIColor imageWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
    [self.sendEmailBtn setBackgroundImage:[UIColor imageWithHexString:@"#41D395"] forState:UIControlStateSelected];
    [self.sendEmailBtn addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendEmailBtn];
}

-(void)textFieldValueChanged:(UITextField*)textField{
    BOOL validEmail = [YGStringUtil validEmail:self.emailAccountTf.text];;
    if (validEmail) {
        self.sendEmailBtn.selected = YES;
    }else{
        self.sendEmailBtn.selected = NO;
    }
}

-(void)sendEmail{
    //
    if (self.sendEmailBtn.selected==YES) {
        NSString *requestUrl = URLForge(@"/user/email/findPassWord");
        [YGHUD loading:self.view];
        [[YGNetworkService instance] networkWithUrl:requestUrl requsetType:POST params:@{@"email":self.emailAccountTf.text} successBlock:^(id data) {
            NSDictionary *result = [data objectForKey:@"result"];
            int code = [[result objectForKey:@"code"] intValue];
            NSString *msg = [result objectForKey:@"msg"];
            if (code==1) {
                [YGTopAlert alert:msg bkColorCode:@"#41D395"];
                //
                YGResetPasswordController *controller = [[YGResetPasswordController alloc] init];
                controller.fromWorkourChangeNewChallenge = self.fromWorkourChangeNewChallenge;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                [YGTopAlert alert:msg bkColorCode:@"#F11900"];
            }
            [YGHUD hide:self.view];
            
        } errorBlock:^(NSError *error) {
            [YGHUD hide:self.view];
        }];
    }
}

-(void)hideKeyboard{
    [self.emailAccountTf resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
