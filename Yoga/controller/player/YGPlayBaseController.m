//
//  YGPlayBaseController.m
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGAppDelegate.h"
#import "YGPlayBaseController.h"
@interface YGPlayBaseController ()
@property (nonatomic,weak) YGAppDelegate *appDelegate;
@end

@implementation YGPlayBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.appDelegate.forceLandscape=YES;
    self.navigationController.navigationBarHidden = YES;
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.appDelegate.forceLandscape=NO;
    self.navigationController.navigationBarHidden = NO;
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
}

-(YGAppDelegate*)appDelegate{
    return (YGAppDelegate*)[UIApplication sharedApplication].delegate;
}

-(void)exit{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
