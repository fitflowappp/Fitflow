//
//  YGRoutineStopCommand.m
//  Yoga
//
//  Created by lyj on 2017/9/25.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGStringUtil.h"
#import "YGRoutinePauseCommand.h"

@implementation YGRoutinePauseCommand
-(void)execute{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/yoga/challenge/%@/workout/%@/routine/%@/stop/%f",cRequestDomain,self.chanllengeID,self.workoutID,self.routineID,self.seconds];
    [self sendRequestWithUrl:requestUrl method:PUT];
}

-(void)successHandle:(id)data{
    if ([YGStringUtil notNull:data]) {
        NSDictionary *result = [data objectForKey:@"result"];
        self.successBlock(result);
    }
}

-(void)errorHandle:(NSError *)error{
    self.errorBlock(error);
}
@end
