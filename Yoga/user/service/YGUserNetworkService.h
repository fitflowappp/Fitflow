//
//  YGUserNetworkService.h
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGUserNetworkService : NSObject
+ (YGUserNetworkService *)instance;

-(void)anonymousLoginSucessBlock:(SUCCESS_BLOCK)sucessBlock failureBlcok:(FAILURE_BLOCK)errorBlock;

-(void)fetchUserAchievementSucessBlock:(SUCCESS_BLOCK)sucessBlock failureBlcok:(FAILURE_BLOCK)errorBlock;

-(void)loginWithFacebookToken:(NSString*)token sucessBlock:(SUCCESS_BLOCK)sucessBlock failureBlcok:(FAILURE_BLOCK)errorBlock;

-(void)scheduleWithParams:(NSDictionary*)params sucessBlock:(SUCCESS_BLOCK)sucessBlock failureBlcok:(FAILURE_BLOCK)errorBlock;

-(void)fetchUserScheduleInfoSucessBlock:(SUCCESS_BLOCK)sucessBlock failureBlcok:(FAILURE_BLOCK)errorBlock;

-(void)resetPassword:(NSString*)password key:(NSString*)key sucessBlock:(SUCCESS_BLOCK)sucessBlock failureBlcok:(FAILURE_BLOCK)errorBlock;

-(void)loginWithEmail:(NSString*)email password:(NSString*)password sucessBlock:(SUCCESS_BLOCK)sucessBlock failureBlcok:(FAILURE_BLOCK)errorBlock;

-(void)signupWithEmail:(NSString*)email password:(NSString*)password sucessBlock:(SUCCESS_BLOCK)sucessBlock failureBlcok:(FAILURE_BLOCK)errorBlock;


@end
