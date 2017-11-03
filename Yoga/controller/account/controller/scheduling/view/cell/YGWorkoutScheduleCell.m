//
//  YGWorkoutScheduleCell.m
//  Yoga
//
//  Created by lyj on 2017/10/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGWorkoutScheduleCell.h"
@interface YGWorkoutScheduleCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@end
@implementation YGWorkoutScheduleCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setWorkoutScheduleCell];
    }
    return self;
}

-(void)setWorkoutScheduleCell{
    [self addTitleLabel];
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    self.layer.cornerRadius = self.frame.size.height/2.0;
}

-(void)addTitleLabel{
    self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14*SCALE];
    [self addSubview:self.titleLabel];
}

-(void)setShouldLigth:(BOOL)shouldLigth{
    if (shouldLigth!=_shouldLigth) {
        _shouldLigth = shouldLigth;
        self.backgroundColor = shouldLigth?[UIColor colorWithHexString:@"#41D395"]:[UIColor colorWithHexString:@"#ECECEC"];
        self.titleLabel.textColor = shouldLigth?[UIColor whiteColor]:[UIColor colorWithHexString:@"#9B9B9B"];
    }
}

-(void)setScheduleTitle:(NSString *)scheduleTitle{
    if (scheduleTitle!=_scheduleTitle) {
        _scheduleTitle = scheduleTitle;
        self.titleLabel.text = scheduleTitle;
    }
}
@end
