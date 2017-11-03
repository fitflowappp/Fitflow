//
//  YGChallengeListService.h
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGChallengeListService : NSObject
+(YGChallengeListService*)instance;

/*挑战列表*/
-(void)fetchChallengeListSucessBlock:(SUCCESS_BLOCK)sucessBlock errorBlock:(FAILURE_BLOCK)errorBlock;

@end
