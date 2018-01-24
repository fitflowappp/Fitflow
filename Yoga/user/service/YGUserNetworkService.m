//
//  YGUserNetworkService.m
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGSheduleCommand.h"
#import "YGEmailLoginCommand.h"
#import "YGEmailSignupCommand.h"
#import "YGAchievementCommand.h"
#import "YGUserNetworkService.h"
#import "YGFetchSheduleCommand.h"
#import "YGFacebookLoginCommand.h"
#import "YGResetPasswordCommand.h"
#import "YGAnonymousLoginCommand.h"
@implementation YGUserNetworkService
+ (YGUserNetworkService *)instance{
    static YGUserNetworkService *userNetworkService = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        userNetworkService = [[YGUserNetworkService alloc] init];
    });
    return userNetworkService;
}

-(void)anonymousLoginSucessBlock:(SUCCESS_BLOCK)sucessBlock failureBlcok:(FAILURE_BLOCK)errorBlock{
    YGAnonymousLoginCommand *command = [[YGAnonymousLoginCommand alloc] init];
    command.errorBlock = errorBlock;
    command.successBlock = sucessBlock;
    [command execute];
}

-(void)fetchUserAchievementSucessBlock:(SUCCESS_BLOCK)sucessBlock failureBlcok:(FAILURE_BLOCK)errorBlock{
    YGAchievementCommand *command = [[YGAchievementCommand alloc] init];
    command.errorBlock = errorBlock;
    command.successBlock = sucessBlock;
    [command execute];
}

-(void)loginWithFacebookToken:(NSString*)token sucessBlock:(SUCCESS_BLOCK)sucessBlock failureBlcok:(FAILURE_BLOCK)errorBlock{
    YGFacebookLoginCommand *command = [[YGFacebookLoginCommand alloc] init];
    command.token = token;
    command.errorBlock = errorBlock;
    command.successBlock = sucessBlock;
    [command execute];
}

-(void)scheduleWithParams:(NSDictionary*)params sucessBlock:(SUCCESS_BLOCK)sucessBlock failureBlcok:(FAILURE_BLOCK)errorBlock{
    YGSheduleCommand *command = [[YGSheduleCommand alloc] init];
    command.params = params;
    command.errorBlock = errorBlock;
    command.successBlock = sucessBlock;
    [command execute];
}

-(void)fetchUserScheduleInfoSucessBlock:(SUCCESS_BLOCK)sucessBlock failureBlcok:(FAILURE_BLOCK)errorBlock{
    YGFetchSheduleCommand *command = [[YGFetchSheduleCommand alloc] init];
    command.errorBlock = errorBlock;
    command.successBlock = sucessBlock;
    [command execute];
}

-(void)loginWithEmail:(NSString*)email password:(NSString*)password sucessBlock:(SUCCESS_BLOCK)sucessBlock failureBlcok:(FAILURE_BLOCK)errorBlock{
    YGEmailLoginCommand *command = [[YGEmailLoginCommand alloc] init];
    command.email = email;
    command.password = password;
    command.successBlock = sucessBlock;
    command.errorBlock = errorBlock;
    [command execute];
}

-(void)signupWithEmail:(NSString*)email password:(NSString*)password sucessBlock:(SUCCESS_BLOCK)sucessBlock failureBlcok:(FAILURE_BLOCK)errorBlock{
    YGEmailSignupCommand *command = [[YGEmailSignupCommand alloc] init];
    command.email = email;
    command.password = password;
    command.successBlock = sucessBlock;
    command.errorBlock = errorBlock;
    [command execute];
}

-(void)resetPassword:(NSString*)password key:(NSString*)key sucessBlock:(SUCCESS_BLOCK)sucessBlock failureBlcok:(FAILURE_BLOCK)errorBlock{
    YGResetPasswordCommand *command = [[YGResetPasswordCommand alloc] init];
    command.key = key;
    command.password = password;
    command.successBlock = sucessBlock;
    command.errorBlock = errorBlock;
    [command execute];
    
}



@end
