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
#import "YGLoginController.h"
#import "YGSignUpController.h"
#import "YGUserNetworkService.h"
#import "YGGuideLoginController.h"

@interface YGGuideLoginController ()

@end

@implementation YGGuideLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItem];
    [self setFacebookLoginSubviews];
    [self.navigationItem setTitle:@"SIGN UP"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)setFacebookLoginSubviews{
    CGFloat scale = self.scale;
    CGFloat width = self.view.frame.size.width;
    CGFloat loginBtnMargin = 16;
    CGFloat loginBtnHeight = (width-loginBtnMargin*2)*(44/343.0);
    /**/
    UIImageView *logoImv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-c"]];
    logoImv.center = CGPointMake(GET_SCREEN_WIDTH/2,56+logoImv.frame.size.height/2);
    [self.view addSubview:logoImv];
    /**/
    CGRect titleRect = CGRectMake(0,CGRectGetMaxY(logoImv.frame)+39*scale,width,20);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Thank you for using Fitflow!";
    titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
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
    subTitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    subTitleLabel.text = @"Register now to access more free content, track your progress, and share with friends.";
    [subTitleLabel sizeToFit];
    subTitleRect.size.height = subTitleLabel.frame.size.height;
    subTitleLabel.frame = subTitleRect;
    [self.view addSubview:subTitleLabel];
    /**/
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(loginBtnMargin,GET_SCREEN_HEIGHT-NAV_HEIGHT-loginBtnHeight-24,width-loginBtnMargin*2,loginBtnHeight);
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = loginBtn.frame.size.height/2;
    [loginBtn setBackgroundColor:[UIColor clearColor]];
    [loginBtn setTitle:@"I already have an account" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
    [loginBtn setTitleColor:[UIColor colorWithHexString:@"#4A90E2"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    //
    UIButton *signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpBtn.frame = CGRectMake(loginBtnMargin,loginBtn.frame.origin.y-loginBtnHeight-16,width-loginBtnMargin*2,loginBtnHeight);
    signUpBtn.layer.masksToBounds = YES;
    signUpBtn.layer.cornerRadius = loginBtn.frame.size.height/2;
    signUpBtn.layer.borderWidth = 0.5f;
    signUpBtn.layer.borderColor = [UIColor colorWithHexString:@"#0EC07F"].CGColor;
    [signUpBtn setBackgroundColor:[UIColor clearColor]];
    [signUpBtn setTitle:@"SIGN UP" forState:UIControlStateNormal];
    [signUpBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [signUpBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
    [signUpBtn addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpBtn];
}

-(void)login{
    YGLoginController *controller = [[YGLoginController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.fromWorkourChangeNewChallenge = self.fromWorkourChangeNewChallenge;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)signUp{
    YGSignUpController *controller = [[YGSignUpController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.fromWorkourChangeNewChallenge = self.fromWorkourChangeNewChallenge;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
