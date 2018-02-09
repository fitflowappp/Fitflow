//
//  YGDeepLinkUtil.m
//  Yoga
//
//  Created by 何侨 on 2018/2/6.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGDeepLinkUtil.h"
#import "YGAppDelegate.h"
#import "YGChallengeController.h"
#import "YGSessionController.h"
#import "YGSchedulingController.h"
#import "YGDiscoverController.h"

#define KEY_DEEP_LINK_PARAMS @"KEY_DEEP_LINK_PARAMS"

@implementation YGDeepLinkUtil


+ (void)linkWithDeepLinkParamter:(NSDictionary *)params
{
    NSString *shortUrl = params[@"short-url"];
    if (shortUrl.length<=0) {
        return;
    }
    
    YGAppDelegate *appDelegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
    if ([appDelegate.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        [self pushWithDeepLinkParmater:params];
    } else {
        [self saveWithDeepLinkParmater:params];
    }
}

+ (BOOL)isExistDeepLinkParamsKey
{
    NSDictionary *params = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_DEEP_LINK_PARAMS]];
    if (params.allKeys.count) {
        return YES;
    }
    return NO;
}
+ (void)pushToSaveDeepLinkParams
{
    NSDictionary *params = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_DEEP_LINK_PARAMS]];
    [self pushWithDeepLinkParmater:params];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_DEEP_LINK_PARAMS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void)saveWithDeepLinkParmater:(NSDictionary *)params
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:params];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KEY_DEEP_LINK_PARAMS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)pushWithDeepLinkParmater:(NSDictionary *)params
{
    NSString *shortUrl = params[@"short-url"];
    YGAppDelegate *appDelegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
    UITabBarController *tabar = (UITabBarController *)appDelegate.window.rootViewController;
    UINavigationController *seltedVC = tabar.childViewControllers[tabar.selectedIndex];
    
    if ([shortUrl hasPrefix:@"/challenge/detail"]) {
        YGChallengeController *controller = [YGChallengeController new];
        controller.challengeID = params[@"ChallengeID"];
        controller.hidesBottomBarWhenPushed = YES;
        [seltedVC pushViewController:controller animated:YES];
    } else if ([shortUrl hasPrefix:@"/singles/detail/SingleLock"]) {
        YGSessionController *controller = [YGSessionController new];
        controller.workoutID = params[@"workoutID"];
        controller.isDeepLink = YES;
        controller.isUseLock = YES;
        controller.hidesBottomBarWhenPushed = YES;
        [seltedVC pushViewController:controller animated:YES];
    } else if ([shortUrl hasPrefix:@"/singles/detail/unSingleLock"]) {
        YGSessionController *controller = [YGSessionController new];
        controller.workoutID = params[@"workoutID"];
        controller.isDeepLink = YES;
        controller.isUseLock = NO;
        controller.hidesBottomBarWhenPushed = YES;
        [seltedVC pushViewController:controller animated:YES];
    } else if ([shortUrl hasPrefix:@"/workout/detail"]) {
        YGSessionController *controller = [YGSessionController new];
        controller.workoutID = params[@"workoutID"];
        controller.isDeepLink = YES;
        controller.isUseLock = NO;
        controller.hidesBottomBarWhenPushed = YES;
        [seltedVC pushViewController:controller animated:YES];
    } else if ([shortUrl hasPrefix:@"/Mine/Schedling"]) {
        YGSchedulingController *controller = [[YGSchedulingController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [seltedVC pushViewController:controller animated:YES];
    } else if ([shortUrl hasPrefix:@"/discover/singles"]) {
        tabar.selectedIndex = 1;
        UINavigationController *discoverNav = tabar.childViewControllers[1];
        YGDiscoverController *controller = discoverNav.viewControllers.lastObject;
        controller.optionIndex = 1;
    } else if ([shortUrl hasPrefix:@"/discover/challenge"]) {
        tabar.selectedIndex = 1;
    }
}






@end
