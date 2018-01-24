//
//  YGBackgroundMusicService.h
//  Yoga
//
//  Created by lyj on 2018/1/17.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGBackgroundMusicService : NSObject
+(BOOL)isBackgroundMusicOpen;
+(float)currentBackgroundMusicVolume;
+(NSInteger)currentBackgroundMusicType;
+(void)setBackgroundMusicOpen:(BOOL)open;
+(void)setBackgroundMusicVolume:(float)volume;
+(void)setBackgroundMusicType:(NSInteger)type;
@end
