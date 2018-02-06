//
//  YGSignUpController.m
//  Yoga
//
//  Created by lyj on 2017/12/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGTopAlert.h"
#import "YGAppDelegate.h"
#import "YGAppDelegate.h"
#import "YGStringUtil.h"
#import "YGNetworkService.h"
#import "YGEmaiTextField.h"
#import "YGLoginController.h"
#import "UIColor+Extension.h"
#import "YGLoginController.h"
#import "YGSignUpController.h"
#import "YGPasswordTextField.h"
#import "YGUserNetworkService.h"
#import "YGTermsOfUseController.h"
#import "YGPrivacyPolicyController.h"
#import "YGOnboardingOfHomeController.h"
#import "YGDeepLinkUtil.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
@interface YGSignUpController ()<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UIButton    *skipBtn;
@property (nonatomic,strong) UIButton    *loginBtn;
@property (nonatomic,strong) UIButton    *singupBtn;
@property (nonatomic,strong) UILabel     *signupTipLabel;
@property (nonatomic,strong) UIButton    *faceBookLoginBtn;
@property (nonatomic,strong) UITextView  *policyTextView;
@property (nonatomic,strong) YGEmaiTextField        *emailAccountTf;
@property (nonatomic,strong) YGPasswordTextField *emailPasswordTf;
@end

@implementation YGSignUpController

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

-(void)dealloc{
    
}

-(void)setUpSubviews{
    [super setUpSubviews];
    [self.backGroundImgv setImage:[UIImage imageNamed:@"signup-bk.jpg"]];
    //    [self addSkipBtn];
    [self addSignupTipLabel];
    [self addSingupPolicyTextview];
    [self addEmailAccountTf];
    [self addEmailPasswordTf];
    [self addSingupBtn];
    [self addLoginBtn];
    [self addFaceBookLoginBtn];
}

// V1.4.2 hidden
//-(void)addSkipBtn{
//    CGFloat marginY = (IS_IPHONE_X?72:32*SCALE)-10;
//    CGFloat marginRight = IS_IPHONE_X?32:32*SCALE;
//    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.skipBtn.frame = CGRectMake(self.view.frame.size.width-marginRight-70,marginY,70,16*SCALE+20);
//    [self.skipBtn setTitle:@"Skip" forState:UIControlStateNormal];
//    [self.skipBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
//    [self.skipBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
//    [self.skipBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//    [self.skipBtn addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.skipBtn];
//}


-(void)addSignupTipLabel{
    CGFloat marginX = (56/375.0)*self.view.frame.size.width;
    CGFloat width   = self.view.frame.size.width-marginX*2;
    CGFloat marginY = CGRectGetMaxY(self.backBtn.frame)+16*SCALE;
    CGFloat height  = (24/263.0)*width;
    self.signupTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX,marginY,width,height)];
    self.signupTipLabel.text = @"SIGN UP";
    self.signupTipLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.signupTipLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
    [self.view addSubview:self.signupTipLabel];
}

-(void)addSingupPolicyTextview{
    NSString *termUsString = @"Terms of Use";
    NSString *pravicyString = @"Privacy Policy";
    NSString *policyString = @"Sign up and get access to all videos contents for free. By signing up, you agree with the Terms of Use & Privacy Policy";
    NSMutableAttributedString *policyAttributedString = [[NSMutableAttributedString alloc] initWithString:policyString];
    UIFont *fond = [UIFont fontWithName:@"Lato-Regular" size:14];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 18;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:style forKey:NSParagraphStyleAttributeName];
    [policyAttributedString addAttributes:params range:NSMakeRange(0,policyString.length)];
    [policyAttributedString addAttributes:@{NSFontAttributeName:fond,
                                            NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]
                                            } range:NSMakeRange(0, policyString.length)];
    [policyAttributedString addAttribute:NSLinkAttributeName
                                   value:@"term://"
                                   range:[[policyAttributedString string] rangeOfString:termUsString]];
    [policyAttributedString addAttribute:NSLinkAttributeName
                                   value:@"privacy://"
                                   range:[[policyAttributedString string] rangeOfString:pravicyString]];
    CGFloat marginX = 56*SCALE;
    CGFloat marginY = CGRectGetMaxY(self.signupTipLabel.frame)+12*SCALE;
    CGFloat width =  self.view.frame.size.width-marginX*2;
    CGSize size = [YGStringUtil boundString:policyAttributedString inSize:CGSizeMake(width,MAXFLOAT)];
    
    CGFloat height  = size.height;
    self.policyTextView = [[UITextView alloc] initWithFrame:CGRectMake(marginX,marginY,width,height)];
    self.policyTextView.editable = NO;
    self.policyTextView.delegate = self;
    self.policyTextView.scrollEnabled = NO;
    self.policyTextView.textContainerInset = UIEdgeInsetsZero;
    self.policyTextView.attributedText = policyAttributedString;
    self.policyTextView.backgroundColor = [UIColor clearColor];
    self.policyTextView.linkTextAttributes = @{NSFontAttributeName:fond,
                                               NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#0EC07F"]};
    [self.policyTextView sizeToFit];
    [self.view addSubview:self.policyTextView];
}

-(void)addEmailAccountTf{
    CGFloat marginX = (32/375.0)*self.view.frame.size.width;
    CGFloat width =  self.view.frame.size.width-marginX*2;
    CGFloat height  = (44/311.0)*width;
    CGFloat centerY = CGRectGetMaxY(self.policyTextView.frame)+24*SCALE;
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
    self.emailPasswordTf.clearButtonMode = UITextFieldViewModeAlways;
    self.emailPasswordTf.delegate = self;
    self.emailPasswordTf.secureTextEntry = YES;
    self.emailPasswordTf.layer.masksToBounds = YES;
    self.emailPasswordTf.layer.cornerRadius = self.emailAccountTf.frame.size.height/2;
    self.emailPasswordTf.font  = [UIFont fontWithName:@"Lato-Bold" size:16];
    [self.emailPasswordTf addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.emailPasswordTf];
    //
    NSMutableAttributedString *placehodler = [[NSMutableAttributedString alloc] initWithString:@"Password (min. 6 characters)"];
    [placehodler addAttributes:@{NSFontAttributeName:self.emailPasswordTf.font,
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]
                                 } range:NSMakeRange(0,placehodler.length)];
    self.emailPasswordTf.attributedPlaceholder = placehodler;
    
}

-(void)addSingupBtn{
    CGFloat marginX = (32/375.0)*self.view.frame.size.width;
    CGFloat width = self.view.frame.size.width-marginX*2;
    CGFloat marginY = CGRectGetMaxY(self.emailPasswordTf.frame)+24*SCALE;
    CGFloat height  = (44/311.0)*width;
    self.singupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.singupBtn.frame = CGRectMake(marginX,marginY,self.view.frame.size.width-marginX*2,height);
    self.singupBtn.layer.masksToBounds = YES;
    self.singupBtn.adjustsImageWhenHighlighted = NO;
    self.singupBtn.layer.cornerRadius = self.singupBtn.frame.size.height/2;
    [self.singupBtn setTitle:@"SIGN UP" forState:UIControlStateNormal];
    [self.singupBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.singupBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
    [self.singupBtn setBackgroundImage:[UIColor imageWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
    [self.singupBtn setBackgroundImage:[UIColor imageWithHexString:@"#41D395"] forState:UIControlStateSelected];
    [self.singupBtn addTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.singupBtn];
}

-(void)addFaceBookLoginBtn{
    CGFloat marginX = (32/375.0)*self.view.frame.size.width;
    CGFloat width   = self.view.frame.size.width-marginX*2;
    CGFloat height  = (56/311.0)*width;
    CGFloat marginY = self.loginBtn.frame.origin.y-16*SCALE-height;;
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

-(void)addLoginBtn{
    CGFloat marginX = (32/375.0)*self.view.frame.size.width;
    CGFloat width   = self.view.frame.size.width-marginX*2;
    CGFloat height  = (44/311.0)*width;
    CGFloat marginY = self.view.frame.size.height-24*SCALE-height;
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(marginX,marginY,width,height);
    [self.loginBtn setTitle:@"LOGIN" forState:UIControlStateNormal];
    [self.loginBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
}

#pragma mark
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    if ([URL.scheme isEqualToString:@"term"]) {
        YGTermsOfUseController *controller = [[YGTermsOfUseController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if ([URL.scheme isEqualToString:@"privacy"]){
        YGPrivacyPolicyController *controller = [[YGPrivacyPolicyController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    return NO;
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
        self.singupBtn.selected = YES;
    }else{
        self.singupBtn.selected = NO;
    }
}

#pragma mark

-(void)signup{
    if (self.singupBtn.selected == YES) {
        [YGHUD loading:self.view];
        [[YGUserNetworkService instance] signupWithEmail:self.emailAccountTf.text password:self.emailPasswordTf.text sucessBlock:^(id data) {
            int code = [[data objectForKey:@"code"] intValue];
            [YGHUD hide:self.view];
            if (code==1) {
                [YGTopAlert alert:@"You're signed up. Welcome to Fitflow!" bkColorCode:@"#41D395"];
                if (self.fromBeginWorkout==YES) {
                    if ([YGDeepLinkUtil isExistDeepLinkParamsKey]) {
                        YGAppDelegate *appDelegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
                        [appDelegate initTabBarController];
                        [YGDeepLinkUtil pushToSaveDeepLinkParams];
                    } else {
                        YGOnboardingOfHomeController *controller = [[YGOnboardingOfHomeController alloc] init];
                        [self.navigationController pushViewController:controller animated:YES];
                        return;
                    }
                }
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
                NSString *msg = [data objectForKey:@"msg"];
                [YGTopAlert alert:msg bkColorCode:@"#F11900"];
            }
        } failureBlcok:^(NSError *error) {
            [YGHUD hide:self.view];
        }];
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)login{
    if (self.fromLogin==YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        YGLoginController *controller= [[YGLoginController alloc] init];
        controller.fromSignup = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)skip{
    if (self.fromBeginWorkout) {
        YGOnboardingOfHomeController *controller = [[YGOnboardingOfHomeController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
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
                                       [YGTopAlert alert:@"You're signed up. Welcome to Fitflow!" bkColorCode:@"#41D395"];
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
