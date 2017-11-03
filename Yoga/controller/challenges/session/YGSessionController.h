//
//  YGSessionController.h
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGSession.h"
#import "YGChallenge.h"
#import "YGBaseController.h"

@interface YGSessionController : YGBaseController
@property (nonatomic) BOOL shouldLight;
@property (nonatomic) BOOL isMineChallenge;
@property (nonatomic) NSInteger workoutIndex;
@property (nonatomic,strong) NSString    *workoutID;
@property (nonatomic,strong) YGChallenge *challenge;
@property (nonatomic,strong) YGChallenge *currentUserChalleng;
@end
