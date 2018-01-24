//
//  YGWorkoutFooter.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGStartWorkoutFooter.h"

@implementation YGStartWorkoutFooter
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setChosenChallengeFooter];
    }
    return self;
}
-(void)setChosenChallengeFooter{
    CGFloat margin = 16;
    self.backgroundColor = [UIColor whiteColor];
    self.startWorkoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startWorkoutBtn.frame = CGRectMake(margin,margin,self.frame.size.width-margin*2,self.frame.size.height-margin*2);
    self.startWorkoutBtn.layer.masksToBounds = YES;
    self.startWorkoutBtn.layer.cornerRadius = self.startWorkoutBtn.frame.size.height/2;
    [self.startWorkoutBtn setTitle:@"START NEXT CLASS" forState:UIControlStateNormal];
    [self.startWorkoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startWorkoutBtn.titleLabel setFont:[UIFont fontWithName:@"lato-Bold" size:14]];
    self.startWorkoutBtn.backgroundColor = [UIColor colorWithHexString:@"#41D395"];
    [self addSubview:self.startWorkoutBtn];
}

@end
