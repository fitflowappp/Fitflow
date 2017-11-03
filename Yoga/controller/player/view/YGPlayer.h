//
//  YGPlayer.h
//  Yoga
//
//  Created by lyj on 2017/9/13.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGRoutine.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@protocol YGPlayerDelegate<NSObject>
@optional
-(void)exit;
-(void)restart;
-(void)nextRoutine;
-(void)preRoutine;
-(void)playingToEnd:(YGRoutine*)routine;
-(void)pauseRoutineNetwork:(YGRoutine*)routine;
-(void)skipRoutineNetwork:(YGRoutine*)routine;

@end

@interface YGPlayer : UIView{
    id playbackTimerObserver;
}

//AVPlayer
@property (nonatomic,strong) AVPlayer *player;
//AVPlayer的播放item
//@property (nonatomic,strong) AVPlayerItem *item;
//总时长
@property (nonatomic,assign) CMTime totalTime;
//当前时间
@property (nonatomic,assign) CMTime currentTime;
//资产AVURLAsset
//@property (nonatomic,strong) AVURLAsset *anAsset;
//播放器Playback Rate
@property (nonatomic,assign) CGFloat rate;

@property (nonatomic) float currentSeconds;

@property (nonatomic,strong) YGRoutine *routine;

@property (nonatomic,weak) id<YGPlayerDelegate> delegate;

//与url初始化
-(instancetype)initWithRoutine:(YGRoutine*)routine;
-(void)playRoutine:(YGRoutine*)routine;
//播放
-(void)play;
//暂停
-(void)pause;
//停止
-(void)stop;

@end
