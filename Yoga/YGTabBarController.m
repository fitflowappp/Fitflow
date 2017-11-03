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
#import "YGChallengeListController.h"
#import "YGBaseNavigationController.h"
@interface YGTabBarController ()

@end

@implementation YGTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBar];
    [self setControllers];
    [self.tabBar setTranslucent:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
}

-(void)setTabBar{
    /*设置字体颜色*/
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#414142"], NSForegroundColorAttributeName,nil]  forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"#000000"], NSForegroundColorAttributeName,nil]  forState:UIControlStateSelected];
}

- (void)viewWillLayoutSubviews{
    CGRect tabBarFrame = self.tabBar.frame;
    tabBarFrame.size.height = TAB_BAR_HEIGHT;
    tabBarFrame.origin.y = self.view.frame.size.height - TAB_BAR_HEIGHT;
    self.tabBar.frame = tabBarFrame;
    self.tabBar.backgroundColor = [UIColor whiteColor];
}

-(void)setControllers{
    /*workout*/
    YGWorkoutController *workoutController = [[YGWorkoutController alloc] init];
    YGBaseNavigationController *workoutNavController = [[YGBaseNavigationController alloc] initWithRootViewController:workoutController];
    workoutNavController.tabBarItem.image = [[UIImage imageNamed:@"Bar-fire"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    workoutNavController.tabBarItem.selectedImage=[[UIImage imageNamed:@"Bar-fire-c"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    workoutNavController.tabBarItem.title=@"Workout";
    /*chanllenge*/
    YGChallengeListController *chanlengeController = [[YGChallengeListController alloc] init];
    YGBaseNavigationController *chanlengeNavController = [[YGBaseNavigationController alloc] initWithRootViewController:chanlengeController];
    chanlengeController.tabBarItem.image = [[UIImage imageNamed:@"Bar-star"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    chanlengeController.tabBarItem.selectedImage=[[UIImage imageNamed:@"Bar-star-c"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    chanlengeController.tabBarItem.title=@"Challenges";
    /*account*/
    YGAccountController *accountController = [[YGAccountController alloc] init];
    YGBaseNavigationController *accountNavController = [[YGBaseNavigationController alloc] initWithRootViewController:accountController];
    accountNavController.tabBarItem.image = [[UIImage imageNamed:@"Bar-user"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    accountNavController.tabBarItem.selectedImage=[[UIImage imageNamed:@"Bar-user-c"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    accountNavController.tabBarItem.title=@"Account";
    [self setViewControllers:@[workoutNavController,chanlengeNavController,accountNavController]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
