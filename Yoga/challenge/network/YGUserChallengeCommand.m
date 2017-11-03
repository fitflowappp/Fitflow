//
//  YGUserChallengeCommand.m
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGStringUtil.h"
#import "YGChallenge.h"
#import "YGUserChallengeCommand.h"

@implementation YGUserChallengeCommand
-(void)execute{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",cRequestDomain,@"/yoga/challenge/mine"];
    [self sendRequestWithUrl:requestUrl method:GET];
}

-(void)successHandle:(id)data{
    YGChallenge *challenge;
    if ([YGStringUtil notNull:data]) {
        NSDictionary *result = [data objectForKey:@"result"];
        if ([YGStringUtil notNull:result]) {
            int code = [[result objectForKey:@"code"] intValue];
            if (code==1) {
                NSDictionary *content = [data objectForKey:@"content"];
                if ([YGStringUtil notNull:content]) {
                    challenge = [YGChallenge objectFrom:content];
                    challenge.avail = @(1);
                }
            }
        }
    }
    self.successBlock(challenge);
}

-(void)errorHandle:(NSError *)error{
    self.errorBlock(error);
}

@end
