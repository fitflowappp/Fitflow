//
//  AppDelegate.m
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "Heap.h"
#import "YGKeychainUtil.h"
#import "YGStringUtil.h"
#import "YGUserService.h"
#import "YGAppDelegate.h"
#import "YGNetworkService.h"
#import "YGUserPersistence.h"
#import "YGTabBarController.h"
#import "YGSchedulingController.h"
#import "YGBeginMyWorkoutController.h"
#import "YGBaseNavigationController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "FBSDKMessengerShareKit/FBSDKMessengerSharer.h"
@import Firebase;
@interface YGAppDelegate ()

@end

@implementation YGAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
    [self prepareGeTuiSdk];
    [self initRootController];
    [Heap setAppId:HeapAppID];
#ifdef DEBUG
    [Heap enableVisualizer];
#endif
    [self registerUserNotification];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    return YES;
    /*# Replace this with the GOOGLE_APP_ID from your GoogleService-Info.plist file
     GOOGLE_APP_ID=1:393772736025:ios:51aa693951c87a8a
     
     # Replace the /Path/To/ServiceAccount.json with the path to the key you just downloaded
     "${PODS_ROOT}"/FirebaseCrash/upload-sym "/Users/lyj/Desktop/Yoga/Yoga/FirebaseCrash.json"*/
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    return self.forceLandscape?UIInterfaceOrientationMaskLandscape:UIInterfaceOrientationMaskPortrait;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                          options:options];
}

// Still need this for iOS8
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(nullable NSString *)sourceApplication
         annotation:(nonnull id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}



-(void)initRootController{
    if ([YGUserService instance].localUser.isLogin) {
        [self initTabBarController];
    }else{
        [self initBeginMyWorkoutController];
    }
}

-(void)initBeginMyWorkoutController{
    YGBaseNavigationController *beginMyWorkoutNav = [[YGBaseNavigationController alloc] initWithRootViewController:[[YGBeginMyWorkoutController alloc] init]];
    beginMyWorkoutNav.navigationBarHidden = YES;
    self.window.rootViewController = beginMyWorkoutNav;
    [self.window makeKeyAndVisible];
}

-(void)initTabBarController{
    YGTabBarController *tabBarController = [[YGTabBarController alloc] init];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
}

-(void)backToWorkout{
    YGTabBarController *rootController = (YGTabBarController*)self.window.rootViewController;
    YGBaseNavigationController *rootNav = rootController.viewControllers[rootController.selectedIndex];
    [rootNav popToRootViewControllerAnimated:NO];
    rootController.selectedIndex = 0;
}

#pragma mark push
- (void)registerUserNotification {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}
#pragma mark - iOS 10中收到推送消息
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
// iOS 10: 点击通知进入App时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    completionHandler();
}
#endif
#pragma mark - APP运行中接收到通知(推送)处理
/** APP已经接收到“远程”通知(推送)*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
/*上传diviceToken*/
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken  {
    /*个推*/
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([GeTuiSdk registerDeviceToken:token]==YES) {//a8a84d5a0ad73f48f834f8abeebe6ea355fc6c9bf746f1f24e501dc2b25f280c
        NSLog(@"GeTuiSdk setDeviceToken success");
    }
}
/*注册推送失败*/
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@", error.localizedDescription);
}

#pragma mark - GeTuiSdk
-(void)prepareGeTuiSdk{
    // [ GTSdk ]：自定义渠道
    [GeTuiSdk setChannelId:@"GT-iOS"];
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
}
/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    if ([YGStringUtil notNull:clientId]) {
        NSDictionary *params =  @{@"cid":clientId,@"type":@"ios"};
        NSString *requestUrl = [NSString stringWithFormat:@"%@/yoga/getui/register",cRequestDomain];
        [[YGNetworkService instance] networkWithUrl:requestUrl requsetType:POST params:params successBlock:^(id data) {
            NSLog(@"\n>>[GTSdk RegisterClient]:%@\n\n", clientId);
        } errorBlock:^(NSError *error) {
            
        }];
    }
}
/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>[GTSdk error]:%@\n\n", [error localizedDescription]);
}
/**SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //offLine 区分用户是否离线
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    // 数据转换
    NSDictionary *payloadJson = [NSJSONSerialization JSONObjectWithData:payloadData options:0 error:nil];
    if ([YGStringUtil notNull:payloadJson]&&offLine==NO) {
        NSString *content = [payloadJson objectForKey:@"content"];
        //        NSData *contentData = [[NSData alloc] initWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        //        NSDictionary *contentJson = [NSJSONSerialization JSONObjectWithData:contentData options:0 error:nil];
        int type = [[payloadJson objectForKey:@"type"] intValue];
        if (type ==1) {/*type==1 需要要显示信息*/
            /*App 在前台触发本地推送*/
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.repeatInterval = 0;
            localNotification.alertBody = content;
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            localNotification.fireDate =  [NSDate dateWithTimeIntervalSinceNow:5];
            localNotification.userInfo = [NSDictionary dictionaryWithObject:payloadJson forKey:@"custom"];
            localNotification.applicationIconBadgeNumber = localNotification.applicationIconBadgeNumber+1;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    }
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    // 控制台打印日志
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>[GTSdk ReceivePayload]:%@\n\n", msg);
}
/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // 发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>[GTSdk DidSendMessage]:%@\n\n", msg);
}
/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // 通知SDK运行状态
    NSLog(@"\n>>[GTSdk SdkState]:%u\n\n", aStatus);
}
/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>[GTSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    NSLog(@"\n>>[GTSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}

#pragma mark
-(void)initOpenReminderAlert{
    if ([[YGKeychainUtil load:KEY_IN_KEYCHAIN_FACEBOOK_FIRST_LOGIN] boolValue]==NO&&[[NSUserDefaults standardUserDefaults] boolForKey:KEY_IN_KEYCHAIN_FACEBOOK_FIRST_LOGIN]==NO) {
        if ([self.window.subviews.lastObject isKindOfClass:[YGOpenReminderAlert class]]==NO) {
            YGOpenReminderAlert *openReminder = [[YGOpenReminderAlert alloc] initWithFrame:self.window.bounds];
            [openReminder.openReminderBtn addTarget:self action:@selector(openReminder:) forControlEvents:UIControlEventTouchUpInside];
            [self.window addSubview:openReminder];
            [YGKeychainUtil save:@{KEY_IN_KEYCHAIN_FACEBOOK_FIRST_LOGIN:@(YES)}];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KEY_IN_KEYCHAIN_FACEBOOK_FIRST_LOGIN];
        }
    }
}

-(void)openReminder:(UIButton*)sender{
    YGOpenReminderAlert *openReminder = (YGOpenReminderAlert*)sender.superview.superview;
    [openReminder hide];
    UIViewController *rootController  = self.window.rootViewController;
    if ([rootController isKindOfClass:[YGTabBarController class]]) {
        YGTabBarController *tabBarController = ((YGTabBarController*)rootController);
        UINavigationController *rootNav = tabBarController.viewControllers[tabBarController.selectedIndex];
        YGSchedulingController *controller = [[YGSchedulingController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [rootNav pushViewController:controller animated:YES];
    }
}

@end
