//
//  YGRoutineEndCommand.m
//  Yoga
//
//  Created by lyj on 2017/9/25.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGStringUtil.h"
#import "YGRoutineEndCommand.h"

@implementation YGRoutineEndCommand
-(void)execute{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/yoga/challenge/%@/workout/%@/routine/%@/complete",cRequestDomain,self.chanllengeID,self.workoutID,self.routineID];
    [self sendRequestWithUrl:requestUrl method:PUT];
}

-(void)successHandle:(id)data{
    if ([YGStringUtil notNull:data]) {
        self.successBlock(data);
    }
}

-(void)errorHandle:(NSError *)error{
    self.errorBlock(error);
}

@end
