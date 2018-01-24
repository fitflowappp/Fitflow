//
//  YGChallengeListCommand.m
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGStringUtil.h"
#import "YGChallenge+Extension.h"
#import "YGChallengeListCommand.h"

@implementation YGChallengeListCommand

-(void)execute{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",cRequestDomain,@"/yoga/home"];
    [self sendRequestWithUrl:requestUrl method:GET];
}

-(void)successHandle:(id)data{
    NSMutableArray *challengeList = [NSMutableArray array];
    if ([YGStringUtil notNull:data]) {
        NSDictionary *content = [data objectForKey:@"content"];
        if ([YGStringUtil notNull:content]) {
            NSArray *challenges = [content objectForKey:@"challenges"];
            NSString *currentChallengeID = [content objectForKey:@"currentChallengeId"];
            for(NSDictionary *challengeDictionary in challenges) {
                YGChallenge *challenge = [YGChallenge objectFrom:challengeDictionary];
                if ([challenge.ID isEqualToString:currentChallengeID]) {
                    challenge.isMineChallenge = @(YES);
                    [challengeList insertObject:challenge atIndex:0];
                }else{
                    [challengeList addObject:challenge];
                }
            }
        }
    }
    self.successBlock(challengeList);
}

-(void)errorHandle:(NSError *)error{
    self.errorBlock(error);
}
@end
