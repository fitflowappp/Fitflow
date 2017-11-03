//
//  YGFacebookLoginController.m
//  Yoga
//
//  Created by lyj on 2017/10/15.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGAppDelegate.h"
#import "YGNetworkService.h"
#import "UIColor+Extension.h"
#import "YGUserNetworkService.h"
#import "YGFacebookLoginController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface YGFacebookLoginController ()

@end

@implementation YGFacebookLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItem];
    [self setFacebookLoginSubviews];
    [self.navigationItem setTitle:@"Login with Facebook"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)setFacebookLoginSubviews{
    CGFloat scale = self.scale;
    CGFloat width = self.view.frame.size.width;
    CGFloat loginBtnMargin = 16*scale;
    CGFloat loginBtnHeight = (width-loginBtnMargin*2)*(96/686.0);
    /**/
    UIImageView *logoImv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-c"]];
    logoImv.center = CGPointMake(GET_SCREEN_WIDTH/2,56*scale+logoImv.frame.size.height/2);
    [self.view addSubview:logoImv];
    /**/
    CGRect titleRect = CGRectMake(0,CGRectGetMaxY(logoImv.frame)+39*scale,width,20);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Thank you for using Fitflow!";
    titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16*scale];
    [titleLabel sizeToFit];
    titleRect.size.height = titleLabel.frame.size.height;
    titleLabel.frame = titleRect;
    [self.view addSubview:titleLabel];
    /**/
    CGRect subTitleRect = CGRectMake(59*scale,CGRectGetMaxY(titleLabel.frame)+39*scale,self.view.frame.size.width-59*scale*2,70);
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:subTitleRect];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    subTitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16*scale];
    subTitleLabel.text = @"Log in now to access more free contents & track your progress.";
    [subTitleLabel sizeToFit];
    subTitleRect.size.height = subTitleLabel.frame.size.height;
    subTitleLabel.frame = subTitleRect;
    [self.view addSubview:subTitleLabel];
    /**/
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(loginBtnMargin,GET_SCREEN_HEIGHT-NAV_HEIGHT-loginBtnHeight-loginBtnMargin,width-loginBtnMargin*2,loginBtnHeight);
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = loginBtn.frame.size.height/2;
    [loginBtn setBackgroundColor:[UIColor colorWithHexString:@"#4A90E2"]];
    [loginBtn setTitle:@"LOGIN WITH FACEBOOK" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16*scale]];
    [loginBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginWithFaceBook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    /**/
    UIImageView *faceBookIconImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook-white"]];
    faceBookIconImgv.center = CGPointMake(loginBtnMargin+faceBookIconImgv.frame.size.width/2,loginBtn.frame.size.height/2);
    [loginBtn addSubview:faceBookIconImgv];
}

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
                                       if (ws.fromBeginMyWorkout==YES) {
                                           YGAppDelegate *delegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
                                           [delegate initTabBarController];
                                       }else{
                                           [ws.navigationController popToRootViewControllerAnimated:YES];
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
    NSString *requestUrl = [NSString stringWithFormat:@"%@/user/fblogin/wish",cRequestDomain];
    [[YGNetworkService instance] networkWithUrl:requestUrl requsetType:POST successBlock:^(id data) {
        NSLog(@"post yoga facebook login sucess");
    } errorBlock:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
