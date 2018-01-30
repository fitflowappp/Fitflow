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
@property (nonatomic) BOOL canPlay;
@property (nonatomic) BOOL fromSingle;
@property (nonatomic) BOOL isMineChallenge;
@property (nonatomic) BOOL isMustShare;
@property (nonatomic) BOOL isShareComplete;


@property (nonatomic,strong) NSString    *workoutID;
@property (nonatomic,strong) NSString    *challengeID;
@property (nonatomic,strong) YGChallenge *fromChallenge;
@property (nonatomic,strong) YGChallenge *userCurrentChallenge;
@end
