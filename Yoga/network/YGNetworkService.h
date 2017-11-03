//
//  RDNetworkService.h
//  Reading
//
//  Created by lyj on 2017/8/27.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGNetworkBaseCommand.h"
#import <Foundation/Foundation.h>

@interface YGNetworkService : NSObject
+ (YGNetworkService *)instance;
-(void)networkWithUrl:(NSString*)url requsetType:(REQUEST_TYPE)type successBlock:(SUCCESS_BLOCK)successBlock errorBlock:(FAILURE_BLOCK)errorBlock;
-(void)networkWithUrl:(NSString*)url requsetType:(REQUEST_TYPE)type params:(NSDictionary*)params successBlock:(SUCCESS_BLOCK)successBlock errorBlock:(FAILURE_BLOCK)errorBlock;
@end
