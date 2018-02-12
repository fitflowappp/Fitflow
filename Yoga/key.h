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

/** facebook上传用户行为*/
#define FBEVENTUPDATEKEY_PLAYVIDEO       @"FFPlayVideo"
#define FBEVENTUPDATEKEY_COMPLETEWORKOUT @"FFCompleteWorkout"
#define FBEVENTUPDATEKEY_COMPCHALLENGE   @"FFCompleteChallenge"//
#define FBEVENTUPDATEKEY_EMAILREGISTER   @"FFEmailRegistered"
#define FBEVENTUPDATEKEY_SHARE           @"FFShare"
#define FBEVENTUPDATEKEY_UNLOCK          @"FFUnlock"
#define FBEVENTUPDATEKEY_SHAREWORKOUT(string) [NSString stringWithFormat:@"%@_%@", @"FFShareWorkOut", string]
#define FBEVENTUPDATEKEY_SHARECHANLLENGE(string) [NSString stringWithFormat:@"%@_%@", @"FFShareChallenge", string]
#define FBEVENTUPDATEKEY_UNLOCKPara(string)  [NSString stringWithFormat:@"%@_%@", @"FFUnlock", string]
#define FBEVENTUPDATEKEY_CHALLENGEDETAIL(string) [NSString stringWithFormat:@"%@_%@", @"FFChallengeDetail", string]
#define FBEVENTUPDATEKEY_WORKOUTDETAIL(string) [NSString stringWithFormat:@"%@_%@", @"FFWorkoutDetail", string]
#define FBEVENTUPDATEKEY_WORKOUT(string) [NSString stringWithFormat:@"%@_%@", @"FFWorkoutPlay", string]
#define FBEVENTUPDATEKEY_CHALLENGE(string) [NSString stringWithFormat:@"%@_%@", @"FFChallengeChoose", string]
#define FBEVENTUPDATEKEY_COMPLETEWORKOUTPARA(string) [NSString stringWithFormat:@"%@_%@", @"FFCompleteWorkout", string]
#define FBEVENTUPDATEKEY_COMPCHALLENGEPAR(string) [NSString stringWithFormat:@"%@_%@", @"FFCompleteChallenge", string]
#define FBEVENTUPDATEKEY_PUSH            @"FFPushOn"
#define FBEVENTUPDATEKEY_CALENDAR        @"FFCalendarOn"

#endif
