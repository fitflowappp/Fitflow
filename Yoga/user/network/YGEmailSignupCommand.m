//
//  YGEmailSignupCommand.m
//  Yoga
//
//  Created by lyj on 2017/12/25.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGUserPersistence.h"
#import "YGEmailSignupCommand.h"
#import "NSString+MD5.h"
@implementation YGEmailSignupCommand
-(void)execute{
    NSString *requestUrl  = [NSString stringWithFormat:@"%@%@",cRequestDomain,@"/user/email/register"];
    NSString *md5Password = [NSString stringWithFormat:@"%@Yoga",self.password];
    NSString *subMd5Password = [[md5Password md5] substringWithRange:NSMakeRange(8,16)];
    [self sendRequestWithUrl:requestUrl method:POST parameter:@{@"email":self.email,@"password":subMd5Password}];
    
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
