//
//  YGChallengeService.h
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGChallengeService : NSObject
+(YGChallengeService*)instance;

/*当前的挑战*/
-(void)fetchUserCurrentChallengeSucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock;

-(void)fetchChallengeWithChallengeId:(NSString*)challengeId sucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock;

-(void)changeChallengeWithChallengID:(NSString*)challengeID sucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock;

@end
