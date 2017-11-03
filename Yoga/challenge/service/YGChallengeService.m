//
//  YGChallengeService.m
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGChallengeCommand.h"
#import "YGChallengeService.h"
#import "YGUserChallengeCommand.h"
#import "YGChangeChallengeCommand.h"
@implementation YGChallengeService
+(YGChallengeService*)instance{
    static YGChallengeService *challengeService = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        challengeService = [[YGChallengeService alloc] init];
    });
    return challengeService;
}

/*当前的挑战*/
-(void)fetchUserCurrentChallengeSucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock{
    YGUserChallengeCommand *command = [[YGUserChallengeCommand alloc] init];
    command.errorBlock = errorBlock;
    command.successBlock = sucessBlock;
    [command execute];
}

-(void)fetchChallengeWithChallengeId:(NSString*)challengeId sucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock{
    YGChallengeCommand *command = [[YGChallengeCommand alloc] init];
    command.challengeID = challengeId;
    command.errorBlock = errorBlock;
    command.successBlock = sucessBlock;
    [command execute];
}

-(void)changeChallengeWithChallengID:(NSString*)challengeID sucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock{
    YGChangeChallengeCommand *command = [[YGChangeChallengeCommand alloc] init];
    command.challengeID = challengeID;
    command.errorBlock = errorBlock;
    command.successBlock = sucessBlock;
    [command execute];
}
@end
