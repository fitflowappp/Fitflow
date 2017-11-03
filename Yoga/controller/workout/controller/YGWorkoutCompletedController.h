//
//  YGWorkoutCompletedController.h
//  Yoga
//
//  Created by lyj on 2017/9/25.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGSession.h"
#import "YGChallenge.h"
#import "YGBaseController.h"

@interface YGWorkoutCompletedController : YGBaseController
@property (nonatomic) BOOL   fromDefaultWorkout;
@property (nonatomic,strong) YGSession   *workout;
@property (nonatomic,strong) YGChallenge *challenge;
@end
