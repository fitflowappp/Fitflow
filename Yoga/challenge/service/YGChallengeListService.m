//
//  YGChallengeListService.m
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGChallengeListService.h"
#import "YGChallengeListCommand.h"
@implementation YGChallengeListService
+(YGChallengeListService*)instance{
    static YGChallengeListService *challengeListService = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        challengeListService = [[YGChallengeListService alloc] init];
    });
    return challengeListService;
}

/*挑战列表*/
-(void)fetchChallengeListSucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock{
    YGChallengeListCommand *command = [[YGChallengeListCommand alloc] init];
    command.errorBlock = errorBlock;
    command.successBlock = sucessBlock;
    [command execute];
}
@end
