//
//  YGWorkoutScheduleView.h
//  Yoga
//
//  Created by lyj on 2017/10/12.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGWorkoutScheduleView : UIView
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) NSMutableArray *scheduleStatusList;
-(void)hide;
@end
