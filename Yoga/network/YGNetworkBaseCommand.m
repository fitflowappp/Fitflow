 //
//  RDNetworkBaseCommand.m
//  Reading
//
//  Created by lyj on 17/8/14.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGDeviceUtil.h"
#import "YGUserService.h"
#import "YGNetworkBaseCommand.h"
@interface YGNetworkBaseCommand()
@end
@implementation YGNetworkBaseCommand
-(id)init{
    self = [super init];
    if (self) {
        self.maxRetryCount = 5;
    }
    return self;
}
-(AFHTTPSessionManager*)networkEngine{
    static AFHTTPSessionManager *networkEngine = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        networkEngine = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [self setUpEngine:networkEngine];
    });
    return networkEngine;
}

-(void)setUpEngine:(AFHTTPSessionManager*)mannger{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"yoga" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = YES;
    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    mannger.securityPolicy=securityPolicy;
    mannger.requestSerializer=[AFJSONRequestSerializer serializer];
    mannger.responseSerializer = [AFJSONResponseSerializer serializer];
    ((AFJSONResponseSerializer*)(mannger.responseSerializer)).removesKeysWithNullValues = YES;
    [mannger.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@",
                                         [mannger.requestSerializer.HTTPRequestHeaders objectForKey:@"User-Agent" ], [YGDeviceUtil version]] forHTTPHeaderField:@"User-Agent"];
}

-(void)sendRequestWithUrl:(NSString *)url method:(REQUEST_TYPE)requestType{
    [self sendRequestWithUrl:url method:requestType parameter:nil];
}

-(void)sendRequestWithUrl:(NSString *)url method:(REQUEST_TYPE)requestType parameter:(NSDictionary*)params{
    NSString *requestMethod = @"POST";
    if (requestType==GET) {
        requestMethod = @"GET";
    }else if (requestType==PUT) {
        requestMethod = @"PUT";
    }else if (requestType==DELETE) {
        requestMethod = @"DELETE";
    }
    NSString *encodingURLString=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest * request=[[self networkEngine].requestSerializer requestWithMethod:requestMethod URLString:encodingURLString parameters:params error:nil];
    request.timeoutInterval = 10;
    
    NSLog(@"sessionID:--%@", [[YGUserService instance] localUser].sessionId);
   [request setValue:[[YGUserService instance] localUser].sessionId forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *dataTask = [[self networkEngine] dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
        //NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if (error){
            [self errorHandle:error];
        } else{
            [self successHandle:responseObject];
        }
    }];
    [dataTask resume];
}

-(void)errorHandle:(NSError *)error{
    if (self.errorBlock) {
        self.errorBlock(error);
    }
}

-(void)successHandle:(id)data{
    if (self.successBlock) {
        self.successBlock(data);
    }
}
-(void)execute{
    NSLog(@"Error, SubClass must override this method!");
    
}
@end
