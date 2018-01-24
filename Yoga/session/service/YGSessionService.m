//
//  YGSessionService.m
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGSessionCommand.h"
#import "YGSessionService.h"
#import "YGSinglesListCommand.h"
#import "YGUserSinglesListCommand.h"
@implementation YGSessionService
+(YGSessionService*)instance{
    static YGSessionService *sessionService = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sessionService = [[YGSessionService alloc] init];
    });
    return sessionService;
}

-(void)fetchSinglesListSucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock{
    YGSinglesListCommand *command = [[YGSinglesListCommand alloc] init];
    command.errorBlock = errorBlock;
    command.successBlock = sucessBlock;
    [command execute];
}

-(void)fetchUserSinglesListSucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock{
    
    YGUserSinglesListCommand *command = [[YGUserSinglesListCommand alloc] init];
    command.errorBlock = errorBlock;
    command.successBlock = sucessBlock;
    [command execute];
}

-(void)fetchSessionWithChallengeID:(NSString*)challengeID sessionID:(NSString*)sessionID sucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock{
    YGSessionCommand *command = [[YGSessionCommand alloc] init];
    command.challengeID = challengeID;
    command.sessionID = sessionID;
    command.errorBlock = errorBlock;
    command.successBlock = sucessBlock;
    [command execute];
}
@end
