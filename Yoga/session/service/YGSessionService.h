//
//  YGSessionService.h
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGSessionService : NSObject
+(YGSessionService*)instance;

-(void)fetchSinglesListSucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock;

-(void)fetchUserSinglesListSucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock;

-(void)fetchSessionWithChallengeID:(NSString*)challengeID sessionID:(NSString*)sessionID sucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock;

-(void)fetchOtherCommandsucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock;

-(void)fetchLockSinglesListSucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock;

-(void)fetchUnlockSinglesListSucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock;

-(void)fetchShareLockSessionWithWorkoutID:(NSString*)workoutID sucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock;

@end
