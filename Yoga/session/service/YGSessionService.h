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

-(void)fetchSessionWithChallengeID:(NSString*)challengeID sessionID:(NSString*)sessionID sucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock;
@end
