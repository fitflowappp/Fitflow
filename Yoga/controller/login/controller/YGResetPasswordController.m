//
//  YGResetPasswordController.m
//  Yoga
//
//  Created by lyj on 2017/12/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGTopAlert.h"
#import "YGAppDelegate.h"
#import "YGEmaiTextField.h"
#import "YGNetworkService.h"
#import "YGUserPersistence.h"
#import "UIColor+Extension.h"
#import "YGPasswordTextField.h"
#import "YGResetPasswordController.h"
#import "YGUserNetworkService.h"
@interface YGResetPasswordController ()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel  *resetPasswordTipLabel;
@property (nonatomic,strong) UIButton *resetPasswordBtn;
@property (nonatomic,strong) YGEmaiTextField *vertifyCodeTf;
@property (nonatomic,strong) YGPasswordTextField *emailPasswordTf;
@end

@implementation YGResetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItem];
    [self setUpSubviews];
    self.navigationItem.title = @"RESET PASSWORD";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)setUpSubviews{
    [self addResetPasswordTipLabel];
    [self addVertifyCodeTf];
    [self addEmailPasswordTf];
    [self addResetPasswordBtn];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
}

-(void)addResetPasswordTipLabel{
    CGFloat marginY = 16*SCALE;
    CGFloat marginX = (16/375.0)*self.view.frame.size.width;
    CGFloat witdh   = self.view.frame.size.width-marginX*2;
    self.resetPasswordTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX,marginY,witdh,100)];
    self.resetPasswordTipLabel.numberOfLines = 0;
    self.resetPasswordTipLabel.textColor = [UIColor colorWithHexString:@"#7B7B7B"];
    self.resetPasswordTipLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    self.resetPasswordTipLabel.text = @"Please enter the verification code from the email you received, plus a new password of at least 6 characters below.";
    [self.resetPasswordTipLabel sizeToFit];
    self.resetPasswordTipLabel.frame = CGRectMake(marginX,marginY,witdh,self.resetPasswordTipLabel.frame.size.height);
    [self.view addSubview:self.resetPasswordTipLabel];
}

-(void)addVertifyCodeTf{
    CGFloat marginX = (16/375.0)*self.view.frame.size.width;
    CGFloat width =  self.view.frame.size.width-marginX*2;
    CGFloat height  = (44/343.0)*width;
    CGFloat marginY = CGRectGetMaxY(self.resetPasswordTipLabel.frame)+24*SCALE;
    self.vertifyCodeTf = [[YGEmaiTextField alloc] initWithFrame:CGRectMake(marginX,marginY,width,height)];
    self.vertifyCodeTf.backgroundColor = [UIColor colorWithHexString:@"#ECECEC" alpha:0.7];
    self.vertifyCodeTf.textColor = [UIColor colorWithHexString:@"#000000"];
    self.vertifyCodeTf.layer.masksToBounds = YES;
    self.vertifyCodeTf.delegate = self;
    self.vertifyCodeTf.keyboardType = UIKeyboardTypeNumberPad;
    self.vertifyCodeTf.layer.cornerRadius = self.vertifyCodeTf.frame.size.height/2;
    self.vertifyCodeTf.font  = [UIFont fontWithName:@"Lato-Bold" size:16];
    [self.vertifyCodeTf addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.vertifyCodeTf];
    //
    NSMutableAttributedString *placehodler = [[NSMutableAttributedString alloc] initWithString:@"Verification Code"];
    [placehodler addAttributes:@{NSFontAttributeName:self.vertifyCodeTf.font,
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#CCCCCC"]
                                 } range:NSMakeRange(0,placehodler.length)];
    self.vertifyCodeTf.attributedPlaceholder = placehodler;
    
}

-(void)addEmailPasswordTf{
    CGFloat marginX = (16/375.0)*self.view.frame.size.width;
    CGFloat width =  self.view.frame.size.width-marginX*2;
    CGFloat height  = (44/343.0)*width;
    CGFloat marginY = CGRectGetMaxY(self.vertifyCodeTf.frame)+16*SCALE;
    self.emailPasswordTf = [[YGPasswordTextField alloc] initWithFrame:CGRectMake(marginX,marginY,width,height)];
    self.emailPasswordTf.backgroundColor = [UIColor colorWithHexString:@"#ECECEC" alpha:0.7];
    self.emailPasswordTf.textColor = [UIColor colorWithHexString:@"#000000"];
    self.emailPasswordTf.layer.masksToBounds = YES;
    self.emailPasswordTf.delegate = self;
    self.emailPasswordTf.secureTextEntry = YES;
    self.emailPasswordTf.layer.cornerRadius = self.emailPasswordTf.frame.size.height/2;
    self.emailPasswordTf.font  = [UIFont fontWithName:@"Lato-Bold" size:16];
    [self.emailPasswordTf addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.emailPasswordTf];
    //
    NSMutableAttributedString *placehodler = [[NSMutableAttributedString alloc] initWithString:@"Password (min. 6 characters)"];
    [placehodler addAttributes:@{NSFontAttributeName:self.emailPasswordTf.font,
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#CCCCCC"]
                                 } range:NSMakeRange(0,placehodler.length)];
    self.emailPasswordTf.attributedPlaceholder = placehodler;
    [self.view addSubview:self.emailPasswordTf];
}

-(void)addResetPasswordBtn{
    CGFloat marginX = (16/375.0)*self.view.frame.size.width;
    CGFloat width =  self.view.frame.size.width-marginX*2;
    CGFloat height  = (44/343.0)*width;
    CGFloat marginY = CGRectGetMaxY(self.emailPasswordTf.frame)+24*SCALE;
    self.resetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.resetPasswordBtn.frame = CGRectMake(marginX,marginY,width,height);
    self.resetPasswordBtn.layer.masksToBounds = YES;
    self.resetPasswordBtn.adjustsImageWhenHighlighted = NO;
    self.resetPasswordBtn.layer.cornerRadius = self.resetPasswordBtn.frame.size.height/2;
    [self.resetPasswordBtn setTitle:@"CONFIRM" forState:UIControlStateNormal];
    [self.resetPasswordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.resetPasswordBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
    [self.resetPasswordBtn setBackgroundImage:[UIColor imageWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
    [self.resetPasswordBtn setBackgroundImage:[UIColor imageWithHexString:@"#41D395"] forState:UIControlStateSelected];
    [self.resetPasswordBtn addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.resetPasswordBtn];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > (textField==self.vertifyCodeTf?6:16)) ? NO : YES;
}

-(void)textFieldValueChanged:(UITextField*)textField{
    BOOL validPassword = self.emailPasswordTf.text.length>=6&&self.emailPasswordTf.text.length<=16;
    BOOL validVertifyCode = self.vertifyCodeTf.text.length==6?YES:NO;
    if (validPassword&&validVertifyCode) {
        self.resetPasswordBtn.selected = YES;
    }else{
        self.resetPasswordBtn.selected = NO;
    }
}

-(void)resetPassword{
    if (self.resetPasswordBtn.selected==YES) {
        [YGHUD loading:self.view];
        [[YGUserNetworkService instance] resetPassword:self.emailPasswordTf.text key:self.vertifyCodeTf.text sucessBlock:^(id data) {
            int code = [[data objectForKey:@"code"] intValue];
            NSString *msg = [data objectForKey:@"msg"];
            if (code==1) {
                [YGTopAlert alert:msg bkColorCode:@"#41D395"];
                YGAppDelegate *appDelegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
                if ([appDelegate.window.rootViewController isKindOfClass:[UITabBarController class]]) {
                    UITabBarController *tabBarController = (UITabBarController*)appDelegate.window.rootViewController;
                    UINavigationController *rootNav = (UINavigationController*)(tabBarController.viewControllers[tabBarController.selectedIndex]);
                    if (self.fromWorkourChangeNewChallenge==YES) {
                        tabBarController.selectedIndex = 1;
                    }
                    [rootNav popToRootViewControllerAnimated:YES];
                }else{
                    [appDelegate initTabBarController];
                }
            }else{
                [YGTopAlert alert:msg bkColorCode:@"#F11900"];
                NSLog(@"msg: facebool login error\n %@",msg);
            }
            [YGHUD hide:self.view];
        } failureBlcok:^(NSError *error) {
            [YGHUD hide:self.view];
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:self.view];
        }];
    }
}

-(void)hideKeyboard{
    [self.vertifyCodeTf resignFirstResponder];
    [self.emailPasswordTf resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
