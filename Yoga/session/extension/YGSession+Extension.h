//
//  YGSession+Extension.h
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGRoutine.h"
#import "YGSession.h"

@interface YGSession (Extension)
@property (nonatomic,strong) NSNumber *decriptionHeight;
@property (nonatomic,strong) NSMutableAttributedString *attributedDescription;

-(YGRoutine*)currentRoutine;
-(BOOL)complete;
@end
