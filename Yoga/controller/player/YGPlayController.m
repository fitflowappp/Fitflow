//
//  YGPlayController.m
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGNetworkService.h"
#import "YGStringUtil.h"
#import "YGAppDelegate.h"
#import "YGRoutineService.h"
#import "YGPlayController.h"
#import "YGDownVideoService.h"
#import "YGBackgroundMusicService.h"
#import "YGWorkoutCompletedController.h"
#import "YGPlayBackgroundMusicController.h"
@interface YGPlayController ()
@property (nonatomic,strong) YGPlayer *player;
@property (nonatomic,assign) BOOL setBackgroundMusic;
@end

@implementation YGPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self preparePlay];
    self.view.backgroundColor = [UIColor blackColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.setBackgroundMusic) {
        self.setBackgroundMusic = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    if (self.setBackgroundMusic==NO) {
        [super viewWillDisappear:animated];
        [self.player pause];
    }
}

-(void)dealloc{
    [self.player stop];
}

-(void)preparePlay{
    if (self.session.routineList.count) {
        YGRoutine *currentRoutine = self.session.routineList[0];
        self.player = [[YGPlayer alloc] initWithSession:self.session];
        self.player.delegate = self;
        [self.player playRoutine:currentRoutine];
        [self.view addSubview:self.player];
        [self startPlayingNetWork:currentRoutine];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[YGDownVideoService instance] downSessionAllVideo:self.session];
        });
    }
}

-(void)nextRoutine{
    NSUInteger currentRoutineIndex = [self.session.routineList indexOfObject:self.player.routine];
    if (currentRoutineIndex<self.session.routineList.count-1) {
        [self playRoutine:self.session.routineList[currentRoutineIndex+1]];
    }else{
        [self workoutEndPlaying];
    }
}

-(void)preRoutine{
    NSUInteger currentRoutineIndex = [self.session.routineList indexOfObject:self.player.routine];
    if (currentRoutineIndex>0) {
        [self playRoutine:self.session.routineList[currentRoutineIndex-1]];
    }else{
        [self playRoutine:self.session.routineList[0]];
    }
}

-(void)playingToEnd:(YGRoutine*)routine{
    [self nextRoutine];
    [self endPlayingNetwork:routine];
}

-(void)playRoutine:(YGRoutine*)routine{
    [self.player playRoutine:routine];
    [self startPlayingNetWork:routine];
}

-(void)openBackgroundMusic{
    BOOL open = [YGBackgroundMusicService isBackgroundMusicOpen];
    if (open==YES) {
        [self playBackgroundMusic];
    }
}

-(void)closeBackGroundMusic{
    [self pauseBackgroundMusic];
}

-(void)endPlayingNetwork:(YGRoutine*)routine{
    [[YGRoutineService instance] endPlayingWithChallenge:self.challengeID workoutID:self.session.ID routineID:routine.ID successBlock:^(NSDictionary *data) {
        NSDictionary *result = [data objectForKey:@"result"];
        int code = [[result objectForKey:@"code"] intValue];
        NSString *msg = [result objectForKey:@"msg"];
        if (code==1) {
            NSLog(@"msg: sucess network endPlaying%@",msg);
        }else{
            NSLog(@"msg: error network endPlaying%@",msg);
        }
        NSDictionary *content = [data objectForKey:@"content"];
        if ([YGStringUtil notNull:content]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KEY_GENERATE_SHARE_INFO_WHEN_PLAYING object:content];
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"msg: error network endReading%@",error.localizedDescription);
    }];
}

-(void)startPlayingNetWork:(YGRoutine*)routine{
    [[YGRoutineService instance] startPlayingWithChallenge:self.challengeID workoutID:self.session.ID routineID:routine.ID successBlock:^(NSDictionary *result) {
        int code = [[result objectForKey:@"code"] intValue];
        NSString *msg = [result objectForKey:@"msg"];
        if (code==1) {
            NSLog(@"msg: sucess network startPlaying%@",msg);
        }else{
            NSLog(@"msg: error network startPlaying%@",msg);
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"msg: error network startPlaying%@",error.localizedDescription);
    }];
}

-(void)pauseRoutineNetwork:(YGRoutine *)routine{
    [[YGRoutineService instance] pausePlayingWithChallenge:self.challengeID workoutID:self.session.ID routineID:routine.ID seconds:self.player.currentSeconds successBlock:^(NSDictionary *result) {
        int code = [[result objectForKey:@"code"] intValue];
        NSString *msg = [result objectForKey:@"msg"];
        if (code==1) {
            NSLog(@"msg: sucess network pausePlaying%@",msg);
        }else{
            NSLog(@"msg: error network pausePlaying%@",msg);
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"msg: error network pausePlaying%@",error.localizedDescription);
    }];
}

-(void)skipRoutineNetwork:(YGRoutine*)routine{
    [[YGRoutineService instance] skipPlayingWithChallenge:self.challengeID workoutID:self.session.ID routineID:routine.ID successBlock:^(NSDictionary *data) {
        NSDictionary *result = [data objectForKey:@"result"];
        int code = [[result objectForKey:@"code"] intValue];
        NSString *msg = [result objectForKey:@"msg"];
        if (code==1) {
            NSLog(@"msg: sucess network skipPlaying%@",msg);
        }else{
            NSLog(@"msg: error network skipPlaying%@",msg);
        }
        NSDictionary *content = [data objectForKey:@"content"];
        if ([YGStringUtil notNull:content]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KEY_GENERATE_SHARE_INFO_WHEN_PLAYING object:content];
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"msg: error network skipPlaying%@",error.localizedDescription);
    }];
}

-(void)workoutEndPlaying{
    [self.player pause];
    YGWorkoutCompletedController *controller = [[YGWorkoutCompletedController alloc] init];
    controller.workout = self.session;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)setBackGroundMusic{
    self.setBackgroundMusic = YES;
    YGPlayBackgroundMusicController *controller = [[YGPlayBackgroundMusicController alloc] init];
    controller.playerController = self;
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:controller animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
