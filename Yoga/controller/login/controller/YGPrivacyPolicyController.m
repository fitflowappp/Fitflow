//
//  YGPrivacyPolicyController.m
//  Yoga
//
//  Created by lyj on 2017/12/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGPrivacyPolicyController.h"

@interface YGPrivacyPolicyController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation YGPrivacyPolicyController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItem];
    [self addWebView];
    self.navigationItem.title = @"PRIVACY POLICY";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)addWebView{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT-NAV_HEIGHT)];
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://fitflow.io/privacy-policy.html?ios=true"]]];
    [self.view addSubview:self.webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [YGHUD loading:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [YGHUD hide:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
