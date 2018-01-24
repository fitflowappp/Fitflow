//
//  YGAnonymousLoginCommand.m
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGStringUtil.h"
#import "YGUserPersistence.h"
#import "YGAnonymousLoginCommand.h"
#define admin 0
@implementation YGAnonymousLoginCommand
-(void)execute{
    NSString *requestUrl = nil;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (admin) {
        requestUrl = [NSString stringWithFormat:@"%@%@",cRequestDomain,@"/user/login/anonymous?client=ios&from=admin"];
    }else{
       requestUrl =  [NSString stringWithFormat:@"%@%@",cRequestDomain,@"/user/login/anonymous?client=ios"];
    }
    [self sendRequestWithUrl:requestUrl method:POST parameter:params];
    
}
-(void)successHandle:(id)data{
    NSDictionary *result = [data objectForKey:@"result"];
    int code = [[result objectForKey:@"code"] intValue];
    if (code==1) {
        NSDictionary *content = [data objectForKey:@"content"];
        [[YGUserPersistence instance] updateLocalUser:content];
    }else{
        NSString *msg = [result objectForKey:@"msg"];
        NSLog(@"msg: anonymousLogin error\n %@",msg);
    }
    self.successBlock(result);
}

-(void)errorHandle:(NSError *)error{
    self.errorBlock(error);
}
@end
