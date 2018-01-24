//
//  YGFacebookLoginCommand.m
//  Yoga
//
//  Created by lyj on 2017/10/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGStringUtil.h"
#import "YGUserPersistence.h"
#import "YGFacebookLoginCommand.h"

@implementation YGFacebookLoginCommand
-(void)execute{
    NSString *requestUrl  = [NSString stringWithFormat:@"%@%@",cRequestDomain,@"/user/facebook/login"];
    [self sendRequestWithUrl:requestUrl method:POST parameter:@{@"token":self.token}];
    
}
-(void)successHandle:(id)data{
    NSDictionary *result = [data objectForKey:@"result"];
    int code = [[result objectForKey:@"code"] intValue];
    if (code==1) {
        NSDictionary *content = [data objectForKey:@"content"];
        [[YGUserPersistence instance] updateLocalUser:content];
    }else{
        NSString *msg = [result objectForKey:@"msg"];
        NSLog(@"msg: facebool login error\n %@",msg);
    }
    self.successBlock(result);
    
    
}

-(void)errorHandle:(NSError *)error{
    self.errorBlock(error);
}
@end
