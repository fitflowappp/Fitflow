//
//  YGAchievementCommand.m
//  Yoga
//
//  Created by lyj on 2017/10/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGStringUtil.h"
#import "YGAchievementCommand.h"

@implementation YGAchievementCommand
-(void)execute{
    NSString *requestUrl  = [NSString stringWithFormat:@"%@%@",cRequestDomain,@"/yoga/my/achievements"];
    [self sendRequestWithUrl:requestUrl method:GET];
}

-(void)successHandle:(id)data{
    NSDictionary *result = [data objectForKey:@"result"];
    int code = [[result objectForKey:@"code"] intValue];
    NSMutableArray *achieveList = [NSMutableArray array];
    if (code==1) {
        NSDictionary *content = [data objectForKey:@"content"];
        if ([YGStringUtil notNull:content]) {
            NSNumber *workoutCount   = [content objectForKey:@"completedWorkoutCount"];
            NSNumber *completedMinutes = [content objectForKey:@"completedMinutes"];
            NSNumber *days = [content objectForKey:@"days"];
            [achieveList addObject:[NSString stringWithFormat:@"%@",workoutCount]];
            [achieveList addObject:[NSString stringWithFormat:@"%@",completedMinutes]];
            [achieveList addObject:[NSString stringWithFormat:@"%@",days]];
        }
    }else{
        NSString *msg = [result objectForKey:@"msg"];
        NSLog(@"msg: fetch achievement error\n %@",msg);
    }
    self.successBlock(achieveList);
}

-(void)errorHandle:(NSError *)error{
    self.errorBlock(error);
}
@end
