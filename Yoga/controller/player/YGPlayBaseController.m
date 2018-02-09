//
//  YGPlayBaseController.m
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGAppDelegate.h"
#import "YGBackgroundMusicService.h"
#import "YGPlayBaseController.h"
#import <AVFoundation/AVFoundation.h>
@interface YGPlayBaseController ()
@property (nonatomic,weak) YGAppDelegate *appDelegate;
@property (nonatomic,strong) AVAudioPlayer *backgroundMusicPlayer;
@end

@implementation YGPlayBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackGroundMusicPlayer];
}

-(void)viewWillAppear:(BOOL)animated{
    self.appDelegate.forceLandscape=YES;
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
}

-(void)setBackGroundMusicPlayer{
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    [avSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [avSession setActive:YES error:nil];
    [self playBackgroundMusicItemIndex:[YGBackgroundMusicService currentBackgroundMusicType]];
}

-(void)setBackGroundMusicVolume:(float)volume{
    self.backgroundMusicPlayer.volume = volume;
}

-(void)playBackgroundMusic{
    if (self.backgroundMusicPlayer.isPlaying==NO) {
        [self.backgroundMusicPlayer play];
    }
}

-(void)pauseBackgroundMusic{
    if (self.backgroundMusicPlayer.isPlaying==YES) {
        [self.backgroundMusicPlayer pause];
    }
}

-(void)playBackgroundMusicItemIndex:(NSInteger)index{
    [self.backgroundMusicPlayer stop];
    self.backgroundMusicPlayer = nil;
    NSString *musicName = @"Classic";
    if (index==1) {
        musicName = @"Relaxing";
    }else if (index==2){
        musicName = @"Energetic";
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:musicName ofType:@"mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    self.backgroundMusicPlayer.volume = [YGBackgroundMusicService currentBackgroundMusicVolume];
}

-(YGAppDelegate*)appDelegate{
    return (YGAppDelegate*)[UIApplication sharedApplication].delegate;
}

-(void)exit{
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(exitWithRemindAlert)]) {
        [self.delegate exitWithRemindAlert];
    }
}
@end
