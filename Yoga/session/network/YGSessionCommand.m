//
//  YGSessionCommand.m
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGSession.h"
#import "YGSessionCommand.h"

@implementation YGSessionCommand
-(void)execute{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/yoga/challenge/%@/workout/%@",cRequestDomain,self.challengeID,self.sessionID];
    [self sendRequestWithUrl:requestUrl method:GET];
}

-(void)successHandle:(id)data{
    NSDictionary *result = [data objectForKey:@"result"];
    int code = [[result objectForKey:@"code"] intValue];
    YGSession *session;
    if (code==1) {
        NSDictionary *content = [data objectForKey:@"content"];
        session = [YGSession objectFrom:content];
    }
    self.successBlock(session);
}

-(void)errorHandle:(NSError *)error{
    self.errorBlock(error);
}
@end
