//
//  YGChallengeController.h
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGChallenge.h"
#import "YGBaseController.h"

@interface YGChallengeController : YGBaseController
@property (nonatomic) BOOL shouldLigth;
@property (nonatomic) BOOL isMineChallenge;
@property (nonatomic,strong) NSString *challengeID;
@property (nonatomic,strong) YGChallenge *userCurrentChallenge;
@end
