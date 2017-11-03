//
//  YGRoutineService.h
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGRoutineService : NSObject
+(YGRoutineService*)instance;
-(void)endPlayingWithChallenge:(NSString*)challengeID workoutID:(NSString*)workoutID routineID:(NSString*)routineID successBlock:(SUCCESS_BLOCK)successBlock errorBlock:(FAILURE_BLOCK)errorBlock;

-(void)skipPlayingWithChallenge:(NSString*)challengeID workoutID:(NSString*)workoutID routineID:(NSString*)routineID  successBlock:(SUCCESS_BLOCK)successBlock errorBlock:(FAILURE_BLOCK)errorBlock;

-(void)startPlayingWithChallenge:(NSString*)challengeID workoutID:(NSString*)workoutID routineID:(NSString*)routineID successBlock:(SUCCESS_BLOCK)successBlock errorBlock:(FAILURE_BLOCK)errorBlock;

-(void)pausePlayingWithChallenge:(NSString*)challengeID workoutID:(NSString*)workoutID routineID:(NSString*)routineID seconds:(float)seconds successBlock:(SUCCESS_BLOCK)successBlock errorBlock:(FAILURE_BLOCK)errorBlock;

@end
