//
//  YGTabBarController.m
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGTabBarController.h"
#import "YGWorkoutController.h"
#import "YGAccountController.h"
#import "YGDiscoverController.h"
#import "YGChallengeListController.h"
#import "YGBaseNavigationController.h"
@interface YGTabBarController ()
@end

@implementation YGTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setTabBar];
    [self setControllers];
    [self.tabBar setTranslucent:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
}

-(void)setTabBar{
    /*设置字体颜色*/
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#A4A3A3"], NSForegroundColorAttributeName,[UIFont fontWithName:@"Lato-Regular" size:10],NSFontAttributeName,nil]  forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#0EC07F"], NSForegroundColorAttributeName,[UIFont fontWithName:@"Lato-Regular" size:10],NSFontAttributeName,nil]  forState:UIControlStateSelected];
}

- (void)viewWillLayoutSubviews{
    for (UITabBarItem *tabBar in self.tabBar.items) {
        tabBar.imageInsets = UIEdgeInsetsMake(6,0,-6,0);
    }
}

-(void)setControllers{
    /*workout*/
    YGWorkoutController *workoutController = [[YGWorkoutController alloc] init];
    YGBaseNavigationController *workoutNavController = [[YGBaseNavigationController alloc] initWithRootViewController:workoutController];
    workoutNavController.tabBarItem.image = [[UIImage imageNamed:@"Bar-home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    workoutNavController.tabBarItem.selectedImage=[[UIImage imageNamed:@"Bar-home-c"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    workoutController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0);
    /*chanllenge*/
    YGDiscoverController *discoverController = [[YGDiscoverController alloc] init];
    YGBaseNavigationController *discoverNavController = [[YGBaseNavigationController alloc] initWithRootViewController:discoverController];
    discoverNavController.tabBarItem.image = [[UIImage imageNamed:@"Bar-discover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    discoverNavController.tabBarItem.selectedImage=[[UIImage imageNamed:@"Bar-discover-c"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    /*account*/
    YGAccountController *accountController = [[YGAccountController alloc] init];
    YGBaseNavigationController *accountNavController = [[YGBaseNavigationController alloc] initWithRootViewController:accountController];
    accountNavController.tabBarItem.image = [[UIImage imageNamed:@"Bar-user"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    accountNavController.tabBarItem.selectedImage=[[UIImage imageNamed:@"Bar-user-c"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self setViewControllers:@[workoutNavController,discoverNavController,accountNavController]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
