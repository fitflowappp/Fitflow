//
//  YGRoutineCommand.h
//  Yoga
//
//  Created by lyj on 2017/9/25.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGNetworkBaseCommand.h"

@interface YGRoutineCommand : YGNetworkBaseCommand
@property (nonatomic,strong) NSString *workoutID;
@property (nonatomic,strong) NSString *routineID;
@property (nonatomic,strong) NSString *chanllengeID;

-(void)endPlayRoutine;
-(void)startPlayRoutine;

@end
