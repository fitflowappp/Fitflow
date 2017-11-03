//
//  YGChallenge+Extension.h
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGSession.h"
#import "YGChallenge.h"
@interface YGChallenge (Extension)
@property (nonatomic,strong) NSNumber *decriptionHeight;
@property (nonatomic,strong) NSNumber *isMineChallenge;
@property (nonatomic,strong) NSMutableAttributedString *attributedDescription;
-(YGSession*)currentWorkout;
@end
