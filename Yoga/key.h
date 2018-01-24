//
//  key.h
//  Yoga
//
//  Created by lyj on 2017/10/17.
//  Copyright © 2017年 lyj. All rights reserved.
//

#ifndef key_h
#define key_h

#define kGtAppId           @"dM8aOA8w0P9ypMrA6zF5g8"
#define kGtAppKey          @"rLEUyFvJyu9r1UeomXhcAA"
#define kGtAppSecret       @"O47pP3QJUs8GZuq7fsZ3N6"

#ifdef DEBUG
#define HeapAppID          @"3747378744"
#else
#define HeapAppID          @"838970016"
#endif
/**
 *用户本地信息
 *服务器直接拉下来的List
 *
 */;
#define KEY_USER_LOCAL_DATA  @"KEY_USER_DATA"

/**
 * 播放界面生成新的分享信息
 *
 * @KEY_GENERATE_NEW_SHARE_INFO      新的分享信息
 */
#define KEY_GENERATE_SHARE_INFO_WHEN_PLAYING  @"KeyGenerateShareInfoWhenPlaying" 
/**
 * BackgroundMusic Settings Key
 *
 * @KEY_BACKGROUND_MUSIC_TYPE            背景音乐类型
 * @KEY_BACKGROUND_MUSIC_VOLUME          背景音乐音量
 * @KEY_BACKGROUND_MUSIC_STATUS          背景音乐是否开启
 */
#define KEY_BACKGROUND_MUSIC_TYPE        @"KeyBackgroundMusicType"
#define KEY_BACKGROUND_MUSIC_VOLUME      @"KeyBackgroundMusicVolume"
#define KEY_BACKGROUND_MUSIC_STATUS      @"KeyBackgroundMusicStatus"
#endif
