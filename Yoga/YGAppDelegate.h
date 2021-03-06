//
//  AppDelegate.h
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GTSDK/GeTuiSdk.h>
#import <UserNotifications/UserNotifications.h>
@interface YGAppDelegate : UIResponder <UIApplicationDelegate,GeTuiSdkDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign , nonatomic) BOOL forceLandscape;

@property (nonatomic,assign) BOOL fitflowUpdated;

-(void)backToWorkout;

-(void)initTabBarController;

-(void)registerUserNotification;

@end

