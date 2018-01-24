//
//  YGUserInfoCell.m
//  Yoga
//
//  Created by lyj on 2018/1/3.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGUserInfoCell.h"
#import "UIColor+Extension.h"
@interface YGUserInfoCell ()
@property (nonatomic,strong) UILabel *daysLabel;
@property (nonatomic,strong) UILabel *minutesLabel;
@property (nonatomic,strong) UILabel *workoutsLabel;
@property (nonatomic,strong) UILabel *daysTipLabel;
@property (nonatomic,strong) UILabel *minutesTipLabel;
@property (nonatomic,strong) UILabel *workoutsTipLabel;
@end
@implementation YGUserInfoCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUserInfoCell];
    }
    return self;
}

-(void)setUpUserInfoCell{
    self.backgroundColor = [UIColor whiteColor];
    [self addWorkoutsLabel];
    [self addMinutesLabel];
    [self addDaysLabel];
    [self addWorkoutsTipLabel];
    [self addMinutesTipLabel];
    [self addDaysTipLabel];
    self.workoutsLabel.text = @"0";
    self.minutesLabel.text = @"0";
    self.daysLabel.text = @"0";
}

-(void)addWorkoutsLabel{
    self.workoutsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,13*MAX(SCALE,1),self.frame.size.width/3.0,36*MAX(SCALE,1))];
    self.workoutsLabel.textAlignment = NSTextAlignmentCenter;
    self.workoutsLabel.font = [UIFont fontWithName:@"Lato-Black" size:20];
    self.workoutsLabel.textColor = [UIColor colorWithHexString:@"#0EC07F"];
    [self addSubview:self.workoutsLabel];
}

-(void)addMinutesLabel{
    self.minutesLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.workoutsLabel.frame),13*MAX(SCALE,1),self.frame.size.width/3.0,36*MAX(SCALE,1))];
    self.minutesLabel.textAlignment = NSTextAlignmentCenter;
    self.minutesLabel.font = [UIFont fontWithName:@"Lato-Black" size:20];
    self.minutesLabel.textColor = [UIColor colorWithHexString:@"#0EC07F"];
    [self addSubview:self.minutesLabel];
}

-(void)addDaysLabel{
    self.daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.minutesLabel.frame),13*MAX(SCALE,1),self.frame.size.width/3.0,36*MAX(SCALE,1))];
    self.daysLabel.textAlignment = NSTextAlignmentCenter;
    self.daysLabel.font = [UIFont fontWithName:@"Lato-Black" size:20];
    self.daysLabel.textColor = [UIColor colorWithHexString:@"#0EC07F"];
    [self addSubview:self.daysLabel];
}

-(void)addWorkoutsTipLabel{
    self.workoutsTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.workoutsLabel.frame),self.frame.size.width/3.0,18*MAX(SCALE,1))];
    self.workoutsTipLabel.text = @"CLASSES";
    self.workoutsTipLabel.textAlignment = NSTextAlignmentCenter;
    self.workoutsTipLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    self.workoutsTipLabel.textColor = [UIColor colorWithHexString:@"#A4A3A3"];
    [self addSubview:self.workoutsTipLabel];
}

-(void)addMinutesTipLabel{
    self.minutesTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.workoutsTipLabel.frame),CGRectGetMaxY(self.minutesLabel.frame),self.frame.size.width/3.0,18*MAX(SCALE,1))];
    self.minutesTipLabel.text = @"MINUTES";
    self.minutesTipLabel.textAlignment = NSTextAlignmentCenter;
    self.minutesTipLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    self.minutesTipLabel.textColor = [UIColor colorWithHexString:@"#A4A3A3"];
    [self addSubview:self.minutesTipLabel];
    
}

-(void)addDaysTipLabel{
    self.daysTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.minutesTipLabel.frame),CGRectGetMaxY(self.daysLabel.frame),self.frame.size.width/3.0,18*MAX(SCALE,1))];
    self.daysTipLabel.text = @"DAYS";
    self.daysTipLabel.textAlignment = NSTextAlignmentCenter;
    self.daysTipLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    self.daysTipLabel.textColor = [UIColor colorWithHexString:@"#A4A3A3"];
    [self addSubview:self.daysTipLabel];
}

-(void)setAchievementList:(NSMutableArray *)achievementList{
    if (achievementList.count==3) {
        self.workoutsLabel.text = [NSString stringWithFormat:@"%@",achievementList[0]];
        self.minutesLabel.text = [NSString stringWithFormat:@"%@",achievementList[1]];
        self.daysLabel.text = [NSString stringWithFormat:@"%@",achievementList[2]];
    }
}
@end
