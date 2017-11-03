//
//  YGRoutineCommand.m
//  Yoga
//
//  Created by lyj on 2017/9/25.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGRoutineCommand.h"

@implementation YGRoutineCommand

-(void)endPlayRoutine{
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/yoga/challenge/%@/workout/%@/routine/%@/complete",cRequestDomain,self.chanllengeID,self.workoutID,self.routineID];
    [self sendRequestWithUrl:requestUrl method:PUT];
}

-(void)startPlayRoutine{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/yoga/challenge/%@/workout/%@/routine/%@/start",cRequestDomain,self.chanllengeID,self.workoutID,self.routineID];
    [self sendRequestWithUrl:requestUrl method:PUT];
}
@end
