//
//  YGPlayController.m
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGStringUtil.h"
#import "YGAppDelegate.h"
#import "YGRoutineService.h"
#import "YGPlayController.h"
#import "YGDownVideoService.h"
#import "YGWorkoutCompletedController.h"
@interface YGPlayController ()
@property (nonatomic,strong) YGPlayer *player;
@end

@implementation YGPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self preparePlay];
    [self setLeftNavigationItem];
    self.view.backgroundColor = [UIColor blackColor];
}
-(void)dealloc{
    [self.player stop];
}

-(void)preparePlay{
    YGRoutine *currentRoutine = [self.session currentRoutine];
    if (self.session.routineList.count) {
        YGRoutine *routine = self.session.routineList[0];
        self.player = [[YGPlayer alloc] initWithRoutine:routine];
        self.player.delegate = self;
        [self.view addSubview:self.player];
        [self startPlayingNetWork:currentRoutine];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[YGDownVideoService instance] downSessionAllVideo:self.session];
        });
    }
}
-(void)restart{
    [self playRoutine:self.session.routineList[0]];
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

-(void)endPlayingNetwork:(YGRoutine*)routine{
    [[YGRoutineService instance] endPlayingWithChallenge:self.challenge.ID workoutID:self.session.ID routineID:routine.ID successBlock:^(NSDictionary *data) {
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
            [[NSNotificationCenter defaultCenter] postNotificationName:KEY_GENERATE_NEW_SHARE_INFO object:content];
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"msg: error network endReading%@",error.localizedDescription);
    }];
}

-(void)startPlayingNetWork:(YGRoutine*)routine{
    [[YGRoutineService instance] startPlayingWithChallenge:self.challenge.ID workoutID:self.session.ID routineID:routine.ID successBlock:^(NSDictionary *result) {
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
    [[YGRoutineService instance] pausePlayingWithChallenge:self.challenge.ID workoutID:self.session.ID routineID:routine.ID seconds:self.player.currentSeconds successBlock:^(NSDictionary *result) {
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
    [[YGRoutineService instance] skipPlayingWithChallenge:self.challenge.ID workoutID:self.session.ID routineID:routine.ID successBlock:^(NSDictionary *data) {
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
            [[NSNotificationCenter defaultCenter] postNotificationName:KEY_GENERATE_NEW_SHARE_INFO object:content];
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"msg: error network skipPlaying%@",error.localizedDescription);
    }];
}

-(void)workoutEndPlaying{
    [self.player pause];
    YGWorkoutCompletedController *controller = [[YGWorkoutCompletedController alloc] init];
    controller.workout = self.session;
    controller.challenge = self.challenge;
    controller.fromDefaultWorkout = self.fromDefaultWorkout;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
