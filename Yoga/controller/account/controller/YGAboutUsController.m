//
//  YGAboutUsController.m
//  Yoga
//
//  Created by lyj on 2017/10/11.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGDeviceUtil.h"
#import "UIColor+Extension.h"
#import "YGAboutUsController.h"
#import "YGUserNetworkService.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface YGAboutUsController ()

@end

@implementation YGAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItem];
    [self.navigationItem setTitle:@"About Us"];
    [self setAboutUsSubviews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)setAboutUsSubviews{
    CGFloat scale = self.scale;
    CGFloat width = self.view.frame.size.width;
    CGFloat loginoutBtnMargin = 16*scale;
    CGFloat loginoutBtnHeight = (width-loginoutBtnMargin*2)*(96/686.0);
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,width,GET_SCREEN_HEIGHT-NAV_HEIGHT-32*scale-loginoutBtnHeight)];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    /**/
    UIImageView *logoImv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-c"]];
    logoImv.center = CGPointMake(GET_SCREEN_WIDTH/2,56*scale+logoImv.frame.size.height/2);
    [scrollView addSubview:logoImv];
    /**/
    NSString *version  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *versionString = [NSString stringWithFormat:@"Fitflow v%@",version];
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(logoImv.frame)+39*scale,width,MAXFLOAT)];
    versionLabel.numberOfLines = 0;
    versionLabel.text = versionString;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    versionLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16*scale];
    [versionLabel sizeToFit];
    versionLabel.frame = CGRectMake(0,CGRectGetMaxY(logoImv.frame)+39*scale,GET_SCREEN_WIDTH,versionLabel.frame.size.height);
    [scrollView addSubview:versionLabel];
    /**/
    NSString *companyString = @"© Zone Internet Ltd.\nHong Kong";
    UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(versionLabel.frame)+19*scale,width,MAXFLOAT)];
    companyLabel.numberOfLines = 0;
    companyLabel.text = companyString;
    companyLabel.textAlignment = NSTextAlignmentCenter;
    companyLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    companyLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16*scale];
    [companyLabel sizeToFit];
    companyLabel.frame = CGRectMake(0,CGRectGetMaxY(versionLabel.frame)+19*scale,width,companyLabel.frame.size.height);
    [scrollView addSubview:companyLabel];
    /**/
    NSString *companyNumberString = @"Incorporation Number\n2572678";
    UILabel *companyNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(companyLabel.frame)+19*scale,width,MAXFLOAT)];
    companyNumberLabel.numberOfLines = 0;
    companyNumberLabel.text = companyNumberString;
    companyNumberLabel.textAlignment = NSTextAlignmentCenter;
    companyNumberLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    companyNumberLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16*scale];
    [companyNumberLabel sizeToFit];
    companyNumberLabel.frame = CGRectMake(0,CGRectGetMaxY(companyLabel.frame)+19*scale,width,companyNumberLabel.frame.size.height);
    [scrollView addSubview:companyNumberLabel];
    /**/
    NSString *emailString = @"help@fitflow.io";
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(companyNumberLabel.frame)+19*scale,width,MAXFLOAT)];
    emailLabel.text = emailString;
    emailLabel.textAlignment = NSTextAlignmentCenter;
    emailLabel.textColor = [UIColor colorWithHexString:@"#0088FF"];
    emailLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16*scale];
    [emailLabel sizeToFit];
    emailLabel.frame = CGRectMake(0,CGRectGetMaxY(companyNumberLabel.frame)+19*scale,width,emailLabel.frame.size.height);
    emailLabel.userInteractionEnabled = YES;
    [emailLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLocalEmail)]];
    [scrollView addSubview:emailLabel];
    scrollView.contentSize = CGSizeMake(0,CGRectGetMaxY(emailLabel.frame));
    /**/
    UIButton *loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOutBtn.frame = CGRectMake(loginoutBtnMargin,GET_SCREEN_HEIGHT-NAV_HEIGHT-loginoutBtnHeight-loginoutBtnMargin,width-loginoutBtnMargin*2,loginoutBtnHeight);
    loginOutBtn.layer.masksToBounds = YES;
    loginOutBtn.layer.cornerRadius = loginOutBtn.frame.size.height/2;
    loginOutBtn.layer.borderWidth = 2.0f;
    loginOutBtn.layer.borderColor = [UIColor colorWithHexString:@"#0EC07F"].CGColor;
    [loginOutBtn setTitle:@"LOGOUT" forState:UIControlStateNormal];
    [loginOutBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
    [loginOutBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16*scale]];
    [loginOutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginOutBtn];
}

-(void)loginOut{
    [YGHUD loading:self.view];
    __weak typeof(self) ws = self;
    [[YGUserNetworkService instance] anonymousLoginSucessBlock:^(NSDictionary *result) {
        [YGHUD hide:ws.view];
        int code = [[result objectForKey:@"code"] intValue];
        if (code==1) {
            FBSDKLoginManager *mannger = [[FBSDKLoginManager alloc] init];
            [mannger logOut];
            [ws.navigationController popViewControllerAnimated:YES];
        }else{
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
        }
    } failureBlcok:^(NSError *error) {
        [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
    }];
    
}

-(void)openLocalEmail{
    MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
    if (mailController) {
        [mailController setToRecipients:@[@"help@fitflow.io"]];
        mailController.mailComposeDelegate = self;
        [self presentViewController:mailController animated:YES completion:nil];
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
