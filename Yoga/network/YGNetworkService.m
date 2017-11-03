//
//  RDNetworkService.m
//  Reading
//
//  Created by lyj on 2017/8/27.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGNetworkService.h"

@implementation YGNetworkService
+ (YGNetworkService *)instance{
    static YGNetworkService *networkService = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        networkService = [[YGNetworkService alloc] init];
    });
    return networkService;
}

-(void)networkWithUrl:(NSString*)url requsetType:(REQUEST_TYPE)type successBlock:(SUCCESS_BLOCK)successBlock errorBlock:(FAILURE_BLOCK)errorBlock{
    [self networkWithUrl:url requsetType:type params:nil successBlock:successBlock errorBlock:errorBlock];
}
-(void)networkWithUrl:(NSString*)url requsetType:(REQUEST_TYPE)type params:(NSDictionary*)params successBlock:(SUCCESS_BLOCK)successBlock errorBlock:(FAILURE_BLOCK)errorBlock{
    YGNetworkBaseCommand *command = [[YGNetworkBaseCommand alloc] init];
    command.successBlock = successBlock;
    command.errorBlock = errorBlock;
    [command sendRequestWithUrl:url method:type parameter:params];
}
@end
