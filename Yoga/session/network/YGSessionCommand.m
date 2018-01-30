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
    if (self.workoutID) {
        NSString *requestUrl = [NSString stringWithFormat:@"%@/yoga/app/workout/single/unlock/%@",cRequestDomain, self.workoutID];
        [self sendRequestWithUrl:requestUrl method:POST parameter:nil];
        return;
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@/yoga/challenge/%@/workout/%@",cRequestDomain,self.challengeID,self.sessionID];
    [self sendRequestWithUrl:requestUrl method:GET];
}

-(void)successHandle:(id)data{
    
    if (_workoutID) {
        return;
    }
    
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
    if (self.actionErrorBlock) {
        self.actionErrorBlock(error);
    }
    if (self.errorBlock) {
        self.errorBlock(error);
    }
}
@end
