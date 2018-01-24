//
//  RDDeviceUtil.m
//  Reading
//
//  Created by lyj on 17/8/24.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGDeviceUtil.h"

@implementation YGDeviceUtil
+(NSString*)version{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *shortVersionStr = infoDic[@"CFBundleShortVersionString"];
    NSString *bundleVersionStr = infoDic[@"CFBundleVersion"];
    NSString *version= [NSString stringWithFormat:@"%@(%@)", shortVersionStr, bundleVersionStr];
    return version;
}

+(BOOL)firstInstallFitflow{
    BOOL firstIntall = [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_INTALLED_FITFLOW"];
    if (firstIntall==NO) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"KEY_INTALLED_FITFLOW"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return !firstIntall;
}

+(BOOL)updated{
    NSString *nowVersion = [YGDeviceUtil version];
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_FITFLOW_VERSION"];
    if (![nowVersion isEqualToString:oldVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:nowVersion forKey:@"KEY_FITFLOW_VERSION"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    return NO;
}

+(BOOL)hasEnteredSinglesInDiscover{
    BOOL ret = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_HAS_ENTERED_CHALLENGES"];
    if (!ret) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"KEY_HAS_ENTERED_CHALLENGES"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return ret;
    
}
+(BOOL)hasEnteredChallengesInDiscover{
    BOOL ret = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_HAS_ENTERED_SINGLES"];
    if (!ret) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"KEY_HAS_ENTERED_SINGLES"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return ret;
}

+(BOOL)hasEnteredScheduling{
    BOOL ret = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_HAS_ENTERED_SCHEDULING"];
    if (!ret) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"KEY_HAS_ENTERED_SCHEDULING"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return ret;
}
@end
