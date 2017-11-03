//
//  YGBeginMyWorkoutPlayer.h
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol YGBeginMyWorkoutPlayerDelegate <NSObject>

-(void)login;

-(void)beginMyWorkout;

@end

@interface YGBeginMyWorkoutPlayer : UIView
//AVPlayer
@property (nonatomic,strong) AVPlayer *player;
//AVPlayer的播放item
@property (nonatomic,strong) AVPlayerItem *item;
//资产AVURLAsset
@property (nonatomic,strong) AVURLAsset *anAsset;

@property (nonatomic,weak) id<YGBeginMyWorkoutPlayerDelegate> delegate;
//与url初始化
-(instancetype)initWithUrl:(NSURL *)url;
//播放
-(void)play;
//暂停
-(void)pause;
//停止 （移除当前视频播放下一个或者销毁视频，需调用Stop方法）
-(void)stop;

@end
