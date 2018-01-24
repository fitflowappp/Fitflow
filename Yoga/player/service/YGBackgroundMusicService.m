//
//  YGBackgroundMusicService.m
//  Yoga
//
//  Created by lyj on 2018/1/17.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGBackgroundMusicService.h"
@implementation YGBackgroundMusicService

+(BOOL)isBackgroundMusicOpen{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_BACKGROUND_MUSIC_STATUS]==nil) {
        return YES;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:KEY_BACKGROUND_MUSIC_STATUS];
}

+(void)setBackgroundMusicOpen:(BOOL)open{
    [[NSUserDefaults standardUserDefaults] setBool:open forKey:KEY_BACKGROUND_MUSIC_STATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(float)currentBackgroundMusicVolume{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_BACKGROUND_MUSIC_VOLUME]==nil) {
        return 0.5;
    }
    return [[NSUserDefaults standardUserDefaults] floatForKey:KEY_BACKGROUND_MUSIC_VOLUME];
}

+(void)setBackgroundMusicVolume:(float)volume{
    [[NSUserDefaults standardUserDefaults] setFloat:volume forKey:KEY_BACKGROUND_MUSIC_VOLUME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSInteger)currentBackgroundMusicType{
    return [[NSUserDefaults standardUserDefaults] integerForKey:KEY_BACKGROUND_MUSIC_TYPE];
}

+(void)setBackgroundMusicType:(NSInteger)type{
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:KEY_BACKGROUND_MUSIC_TYPE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
