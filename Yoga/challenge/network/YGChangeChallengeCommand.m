//
//  YGChangeChallengeCommand.m
//  Yoga
//
//  Created by lyj on 2017/9/26.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGChallenge.h"
#import "YGStringUtil.h"
#import "YGChangeChallengeCommand.h"

@implementation YGChangeChallengeCommand
-(void)execute{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@%@/change",cRequestDomain,@"/yoga/challenge/",self.challengeID];
    [self sendRequestWithUrl:requestUrl method:POST];
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
