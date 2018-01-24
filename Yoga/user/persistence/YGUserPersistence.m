//
//  YGUserPersistence.m
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGStringUtil.h"
#import "YGUserPersistence.h"
#import "YGBackgroundMusicService.h"
#define KEY_SERVICE_BACKGROUND_MUSIC_TYPE        @"musicType"
#define KEY_SERVICE_BACKGROUND_MUSIC_VOLUME      @"musicVolume"
#define KEY_SERVICE_BACKGROUND_MUSIC_STATUS      @"musicStatus"
@implementation YGUserPersistence
+ (YGUserPersistence *)instance{
    static YGUserPersistence *userPersistence = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        userPersistence = [[YGUserPersistence alloc] init];
    });
    return userPersistence;
}
-(void)updateLocalUser:(id)data{
    if ([YGStringUtil notNull:data]) {
        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:data];
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:KEY_USER_LOCAL_DATA];
        /*背景音乐*/
        NSDictionary *userInfo = (NSDictionary*)data;
        if ([userInfo.allKeys containsObject:KEY_SERVICE_BACKGROUND_MUSIC_STATUS]) {
            BOOL musicStaus = [[userInfo objectForKey:KEY_SERVICE_BACKGROUND_MUSIC_STATUS] boolValue];
            [YGBackgroundMusicService setBackgroundMusicOpen:musicStaus];
        }
        if ([userInfo.allKeys containsObject:KEY_SERVICE_BACKGROUND_MUSIC_TYPE]) {
            NSInteger musicType = [[userInfo objectForKey:KEY_SERVICE_BACKGROUND_MUSIC_TYPE] integerValue];
            [YGBackgroundMusicService setBackgroundMusicType:musicType];
        }
        if ([userInfo.allKeys containsObject:KEY_SERVICE_BACKGROUND_MUSIC_VOLUME]) {
            float musicVolume = [[userInfo objectForKey:KEY_SERVICE_BACKGROUND_MUSIC_VOLUME] floatValue];
            [YGBackgroundMusicService setBackgroundMusicVolume:musicVolume];
        }
    }
}
@end
