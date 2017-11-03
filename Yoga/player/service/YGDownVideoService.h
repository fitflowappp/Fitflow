//
//  YGDownLoadVideoService.h
//  Yoga
//
//  Created by lyj on 2017/9/20.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGRoutine.h"
#import "YGSession.h"
@interface YGDownVideoService : NSObject
+ (YGDownVideoService *)instance;

-(void)downVideoWithRoutine:(YGRoutine*)routine successBlock:(SUCCESS_BLOCK)successBlock errorBlock:(FAILURE_BLOCK)errorBlock;

-(void)downSessionAllVideo:(YGSession*)sesssion;

@end
