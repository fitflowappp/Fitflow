//
//  YGLoginController.m
//  Yoga
//
//  Created by lyj on 2017/12/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGTopAlert.h"
#import "YGStringUtil.h"
#import "YGAppDelegate.h"
#import "YGLoginController.h"
#import "UIColor+Extension.h"
#import "YGEmaiTextField.h"
#import "YGNetworkService.h"
#import "YGSignUpController.h"
#import "YGPasswordTextField.h"
#import "YGUserNetworkService.h"
#import "YGForgetPasswordController.h"
#import "YGDeepLinkUtil.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface YGLoginController ()<UITextFieldDelegate>
@property (nonatomic,strong) UIButton    *loginBtn;
@property (nonatomic,strong) UIButton    *singupBtn;
@property (nonatomic,strong) UILabel     *loginTipLabel;
@property (nonatomic,strong) UIButton    *faceBookLoginBtn;
@property (nonatomic,strong) UIButton    *forgetPasswordBtn;
@property (nonatomic,strong) YGEmaiTextField        *emailAccountTf;
@property (nonatomic,strong) YGPasswordTextField *emailPasswordTf;
@end

@implementation YGLoginController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)setUpSubviews{
    [super setUpSubviews];
    [self.backGroundImgv setImage:[UIImage imageNamed:@"login-bk.jpg"]];
    [self addLoginTipLabel];
    [self addEmailAccountTf];
    [self addEmailPasswordTf];
    [self addLoginBtn];
    [self addForgetPasswordBtn];
    [self addSingupBtn];
    [self addFaceBookLoginBtn];
}

-(void)addLoginTipLabel{
    CGFloat marginX = (56/375.0)*self.view.frame.size.width;
    CGFloat width   = self.view.frame.size.width-marginX*2;
    CGFloat marginY = CGRectGetMaxY(self.backBtn.frame)+16*SCALE;
    CGFloat height  = (24/263.0)*width;
    self.loginTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX,marginY,width,height)];
    self.loginTipLabel.text = @"LOGIN";
    self.loginTipLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.loginTipLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
    [self.view addSubview:self.loginTipLabel];
}

-(void)addEmailAccountTf{
    CGFloat marginX = (32/375.0)*self.view.frame.size.width;
    CGFloat width =  self.view.frame.size.width-marginX*2;
    CGFloat height  = (44/311.0)*width;
    CGFloat centerY = CGRectGetMaxY(self.loginTipLabel.frame)+24*SCALE;
    self.emailAccountTf = [[YGEmaiTextField alloc] initWithFrame:CGRectMake(0,0,width,height)];
    self.emailAccountTf.center = CGPointMake(self.view.center.x,centerY+self.emailAccountTf.frame.size.height/2);
    self.emailAccountTf.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.3];
    self.emailAccountTf.textColor = [UIColor colorWithHexString:@"#0EC07F"];
    self.emailAccountTf.layer.masksToBounds = YES;
    self.emailAccountTf.delegate = self;
    self.emailAccountTf.layer.cornerRadius = self.emailAccountTf.frame.size.height/2;
    self.emailAccountTf.font  = [UIFont fontWithName:@"Lato-Bold" size:16];
    [self.emailAccountTf addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.emailAccountTf];
    //
    NSMutableAttributedString *placehodler = [[NSMutableAttributedString alloc] initWithString:@"Email"];
    [placehodler addAttributes:@{NSFontAttributeName:self.emailAccountTf.font,
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]
                                 } range:NSMakeRange(0,placehodler.length)];
    self.emailAccountTf.attributedPlaceholder = placehodler;
    
}

-(void)addEmailPasswordTf{
    CGFloat marginX = (32/375.0)*self.view.frame.size.width;
    CGFloat width =  self.view.frame.size.width-marginX*2;
    CGFloat height  = (44/311.0)*width;
    CGFloat centerY = CGRectGetMaxY(self.emailAccountTf.frame)+16*SCALE;
    self.emailPasswordTf = [[YGPasswordTextField alloc] initWithFrame:CGRectMake(0,0,width,height)];
    self.emailPasswordTf.center = CGPointMake(self.view.center.x,centerY+self.emailPasswordTf.frame.size.height/2);
    self.emailPasswordTf.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.3];
    self.emailPasswordTf.textColor = [UIColor colorWithHexString:@"#0EC07F"];
    self.emailPasswordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailPasswordTf.secureTextEntry = YES;
    self.emailPasswordTf.delegate = self;
    self.emailPasswordTf.layer.masksToBounds = YES;
    self.emailPasswordTf.layer.cornerRadius = self.emailAccountTf.frame.size.height/2;
    self.emailPasswordTf.font  = [UIFont fontWithName:@"Lato-Bold" size:16];
    [self.emailPasswordTf addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.emailPasswordTf];
    //
    NSMutableAttributedString *placehodler = [[NSMutableAttributedString alloc] initWithString:@"Password"];
    [placehodler addAttributes:@{NSFontAttributeName:self.emailPasswordTf.font,
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]
                                 } range:NSMakeRange(0,placehodler.length)];
    self.emailPasswordTf.attributedPlaceholder = placehodler;
}

-(void)addLoginBtn{
    CGFloat marginX = (32/375.0)*self.view.frame.size.width;
    CGFloat width = self.view.frame.size.width-marginX*2;
    CGFloat marginY = CGRectGetMaxY(self.emailPasswordTf.frame)+24*SCALE;
    CGFloat height  = (44/311.0)*width;
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(marginX,marginY,self.view.frame.size.width-marginX*2,height);
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.adjustsImageWhenHighlighted = NO;
    self.loginBtn.layer.cornerRadius = self.loginBtn.frame.size.height/2;
    [self.loginBtn setTitle:@"LOGIN" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.loginBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
    [self.loginBtn setBackgroundImage:[UIColor imageWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIColor imageWithHexString:@"#41D395"] forState:UIControlStateSelected];
    [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
}

-(void)addForgetPasswordBtn{
    CGFloat marginX = (56/375.0)*self.view.frame.size.width;
    CGFloat width   = 110;
    CGFloat marginY = CGRectGetMaxY(self.loginBtn.frame)+16*SCALE;
    CGFloat height  = 18;
    self.forgetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forgetPasswordBtn.frame = CGRectMake(self.view.frame.size.width-width-marginX,marginY, width,height);
    [self.forgetPasswordBtn setTitle:@"Forgot Password" forState:UIControlStateNormal];
    [self.forgetPasswordBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.forgetPasswordBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.forgetPasswordBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [self.forgetPasswordBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetPasswordBtn];
}

-(void)addFaceBookLoginBtn{
    CGFloat marginX = (32/375.0)*self.view.frame.size.width;
    CGFloat width   = self.view.frame.size.width-marginX*2;
    CGFloat height  = (56/311.0)*width;
    CGFloat marginY = self.singupBtn.frame.origin.y-16*SCALE-height;;
    self.faceBookLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.faceBookLoginBtn.frame = CGRectMake(marginX,marginY,width,height);
    self.faceBookLoginBtn.layer.masksToBounds = YES;
    self.faceBookLoginBtn.adjustsImageWhenHighlighted = NO;
    self.faceBookLoginBtn.layer.cornerRadius = self.faceBookLoginBtn.frame.size.height/2;
    self.faceBookLoginBtn.frame = CGRectMake(marginX,marginY,self.view.frame.size.width-marginX*2,height);
    self.faceBookLoginBtn.backgroundColor = [UIColor colorWithHexString:@"#4267B2"];
    NSString *facebookLoginLargeTittle = @"CONTINUE WITH FACEBOOK";
    NSString *facebookLoginSmallTittle = @"We never post without your permission";
    NSMutableAttributedString *facebookLoginTittle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",facebookLoginLargeTittle,facebookLoginSmallTittle]];
    [facebookLoginTittle addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Lato-Regular" size:16],
                                         NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]
                                         } range:NSMakeRange(0,facebookLoginLargeTittle.length)];
    [facebookLoginTittle addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Lato-Regular" size:12],
                                         NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]
                                         } range:NSMakeRange(facebookLoginTittle.length-facebookLoginSmallTittle.length,facebookLoginSmallTittle.length)];
    [self.faceBookLoginBtn setAttributedTitle:facebookLoginTittle forState:UIControlStateNormal];
    self.faceBookLoginBtn.titleLabel.numberOfLines = 0;
    self.faceBookLoginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.faceBookLoginBtn addTarget:self action:@selector(loginWithFaceBook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.faceBookLoginBtn];
}

-(void)addSingupBtn{
    CGFloat marginX = (32/375.0)*self.view.frame.size.width;
    CGFloat width   = self.view.frame.size.width-marginX*2;
    CGFloat height  = (44/311.0)*width;
    CGFloat marginY = self.view.frame.size.height-24*SCALE-height;
    self.singupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.singupBtn.frame = CGRectMake(marginX,marginY,width,height);
    [self.singupBtn setTitle:@"SIGN UP" forState:UIControlStateNormal];
    [self.singupBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [self.singupBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.singupBtn addTarget:self action:@selector(singup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.singupBtn];
}

#pragma mark
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==self.emailPasswordTf) {
        if ([string isEqualToString:@" "]) {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 16) ? NO : YES;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    textField.textColor = [UIColor colorWithHexString:@"#0EC07F"];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.3];
    textField.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
}

-(void)textFieldValueChanged:(UITextField*)textField{
    BOOL validEmail = [YGStringUtil validEmail:self.emailAccountTf.text];;
    BOOL validPassword = self.emailPasswordTf.text.length>=6&&self.emailPasswordTf.text.length<=16;
    if (validEmail&&validPassword) {
        self.loginBtn.selected = YES;
    }else{
        self.loginBtn.selected = NO;
    }
}

#pragma mark

-(void)login{
    if (self.loginBtn.selected==YES) {
        [YGHUD loading:self.view];
        [[YGUserNetworkService instance] loginWithEmail:self.emailAccountTf.text password:self.emailPasswordTf.text sucessBlock:^(id data) {
            int code = [[data objectForKey:@"code"] intValue];
            if (code==1) {
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
                    if ([YGDeepLinkUtil isExistDeepLinkParamsKey]) {
                        [YGDeepLinkUtil pushToSaveDeepLinkParams];
                    }
                }
                [YGTopAlert alert:@"You're signed in. Welcome back!" bkColorCode:@"#41D395"];
            }else{
                NSString *msg = [data objectForKey:@"msg"];
                [YGTopAlert alert:msg bkColorCode:@"#F11900"];
            }
            [YGHUD hide:self.view];
        } failureBlcok:^(NSError *error) {
            
        }];
    }
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)singup{
    if (self.fromSignup==YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        YGSignUpController *controller = [[YGSignUpController alloc] init];
        controller.fromLogin = YES;
        controller.fromBeginWorkout = self.fromBeginWorkout;
        controller.fromWorkourChangeNewChallenge = self.fromWorkourChangeNewChallenge;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)forgetPassword{
    YGForgetPasswordController *controller = [[YGForgetPasswordController alloc] init];
    controller.fromWorkourChangeNewChallenge = self.fromWorkourChangeNewChallenge;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark

-(void)loginWithFaceBook{
    __weak typeof(self) ws = self;
    [YGHUD loading:self.view];
    FBSDKLoginManager *mannger = [[FBSDKLoginManager alloc] init];
    [mannger logOut];
    [mannger logInWithReadPermissions:@[@"email",
                                        @"user_friends",
                                        @"public_profile"]
                   fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                       if (!error) {
                           if (result.isCancelled==YES) {
                               [YGHUD hide:ws.view];
                           }else{
                               
                               [[YGUserNetworkService instance] loginWithFacebookToken:result.token.tokenString sucessBlock:^(NSDictionary *result) {
                                   [YGHUD hide:ws.view];
                                   int code = [[result objectForKey:@"code"] intValue];
                                   if (code==1) {
                                       NSLog(@"msg: facebook logins sucess");
                                       //
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
                                           if ([YGDeepLinkUtil isExistDeepLinkParamsKey]) {
                                               [YGDeepLinkUtil pushToSaveDeepLinkParams];
                                           }
                                       }
                                       [YGTopAlert alert:@"You're signed in. Welcome back!" bkColorCode:@"#41D395"];
                                   }else{
                                       [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
                                   }
                               } failureBlcok:^(NSError *error) {
                                   [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
                               }];
                           }
                           
                       }else{
                           [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
                       }
                   }];
    
    /**/
    //TOOD
    NSString *requestUrl = [NSString stringWithFormat:@"%@/user/fblogin/wish",cRequestDomain];
    [[YGNetworkService instance] networkWithUrl:requestUrl requsetType:POST successBlock:^(id data) {
        NSLog(@"post yoga facebook login sucess");
    } errorBlock:^(NSError *error) {
        NSLog(@"error %@",error.localizedDescription);;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

