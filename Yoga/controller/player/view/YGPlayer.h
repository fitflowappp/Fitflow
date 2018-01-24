//
//  YGPlayer.h
//  Yoga
//
//  Created by lyj on 2017/9/13.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGRoutine.h"
#import "YGSession.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@protocol YGPlayerDelegate<NSObject>
@optional
-(void)exit;
-(void)preRoutine;
-(void)nextRoutine;
-(void)setBackGroundMusic;
-(void)openBackgroundMusic;
-(void)closeBackGroundMusic;
-(void)playingToEnd:(YGRoutine*)routine;
-(void)skipRoutineNetwork:(YGRoutine*)routine;
-(void)pauseRoutineNetwork:(YGRoutine*)routine;
@end

@interface YGPlayer : UIView{
    id playbackTimerObserver;
}
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic) float currentSeconds;
@property (nonatomic,weak) YGRoutine *routine;
@property (nonatomic,weak) YGSession *session;
@property (nonatomic,weak) id<YGPlayerDelegate> delegate;
-(void)play;
-(void)stop;
-(void)pause;
-(void)playRoutine:(YGRoutine*)routine;
-(instancetype)initWithSession:(YGSession *)session;
@end
