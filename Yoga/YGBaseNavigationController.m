//
//  YGBaseNavigationController.m
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "UINavigationBar+Extension.h"
#import "YGBaseNavigationController.h"

@interface YGBaseNavigationController ()

@end

@implementation YGBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.height = @(NAV_HEIGHT-20);
    self.navigationBar.translucent = NO;
    self.navigationBar.shadowImage = [UIImage new];
    //self.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#000000"],NSFontAttributeName:[UIFont fontWithName:@"Lato-Bold" size:24*SCALE]}];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
