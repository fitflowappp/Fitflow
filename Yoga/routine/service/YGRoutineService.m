//
//  YGRoutineService.m
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGRoutineService.h"
#import "YGSkipRoutineCommand.h"
#import "YGRoutineEndCommand.h"
#import "YGRoutineStartCommand.h"
#import "YGRoutinePauseCommand.h"
@implementation YGRoutineService
+(YGRoutineService*)instance{
    static YGRoutineService *routineService = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        routineService = [[YGRoutineService alloc] init];
    });
    return routineService;
}

-(void)endPlayingWithChallenge:(NSString*)challengeID workoutID:(NSString*)workoutID routineID:(NSString*)routineID successBlock:(SUCCESS_BLOCK)successBlock errorBlock:(FAILURE_BLOCK)errorBlock{
    YGRoutineEndCommand *command = [[YGRoutineEndCommand alloc] init];
    command.routineID = routineID;
    command.workoutID = workoutID;
    command.chanllengeID = challengeID;
    command.errorBlock = errorBlock;
    command.successBlock = successBlock;
    [command execute];
}

-(void)startPlayingWithChallenge:(NSString*)challengeID workoutID:(NSString*)workoutID routineID:(NSString*)routineID successBlock:(SUCCESS_BLOCK)successBlock errorBlock:(FAILURE_BLOCK)errorBlock{
    YGRoutineStartCommand *command = [[YGRoutineStartCommand alloc] init];
    command.routineID = routineID;
    command.workoutID = workoutID;
    command.chanllengeID = challengeID;
    command.errorBlock = errorBlock;
    command.successBlock = successBlock;
    [command execute];
}

-(void)pausePlayingWithChallenge:(NSString*)challengeID workoutID:(NSString*)workoutID routineID:(NSString*)routineID seconds:(float)seconds successBlock:(SUCCESS_BLOCK)successBlock errorBlock:(FAILURE_BLOCK)errorBlock{
    YGRoutinePauseCommand *command = [[YGRoutinePauseCommand alloc] init];
    command.routineID = routineID;
    command.workoutID = workoutID;
    command.seconds = seconds;
    command.chanllengeID = challengeID;
    command.errorBlock = errorBlock;
    command.successBlock = successBlock;
    [command execute];
}
-(void)skipPlayingWithChallenge:(NSString*)challengeID workoutID:(NSString*)workoutID routineID:(NSString*)routineID successBlock:(SUCCESS_BLOCK)successBlock errorBlock:(FAILURE_BLOCK)errorBlock{
    YGSkipRoutineCommand *command = [[YGSkipRoutineCommand alloc] init];
    command.routineID = routineID;
    command.workoutID = workoutID;
    command.chanllengeID = challengeID;
    command.errorBlock = errorBlock;
    command.successBlock = successBlock;
    [command execute];
}
@end
