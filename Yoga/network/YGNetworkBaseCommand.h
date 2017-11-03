//
//  RDNetworkBaseCommand.h
//  Reading
//
//  Created by lyj on 17/8/14.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "YGASyncCommandProtocol.h"
#import "AFNetworking/AFNetworking.h"
@interface YGNetworkBaseCommand : NSObject<YGASyncCommandProtocol>
typedef enum REQUEST_TYPE{
    GET    = 0,
    POST   = 1,
    PUT    = 2,
    DELETE =3
}REQUEST_TYPE;
typedef void (^SUCCESS_BLOCK)(id data);
typedef void (^FAILURE_BLOCK)(NSError* error);
@property (nonatomic,copy) FAILURE_BLOCK errorBlock;
@property (nonatomic,copy) SUCCESS_BLOCK successBlock;
@property (nonatomic) int  maxRetryCount;

-(AFHTTPSessionManager*)networkEngine;

- (void)successHandle:(id)data;

- (void)errorHandle:(NSError *)error;

-(void)sendRequestWithUrl:(NSString *)url method:(REQUEST_TYPE)requestType;

-(void)sendRequestWithUrl:(NSString *)url method:(REQUEST_TYPE)requestType parameter:(NSDictionary*)params;

@end
