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
    CGFloat margin = 16*SCALE;
    self.backgroundColor = [UIColor whiteColor];
    self.startWorkoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startWorkoutBtn.frame = CGRectMake(margin,margin,self.frame.size.width-margin*2,self.frame.size.height-margin*2);
    self.startWorkoutBtn.layer.masksToBounds = YES;
    self.startWorkoutBtn.layer.cornerRadius = self.startWorkoutBtn.frame.size.height/2;
    [self.startWorkoutBtn setTitle:@"START WORKOUT" forState:UIControlStateNormal];
    [self.startWorkoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startWorkoutBtn.titleLabel setFont:[UIFont fontWithName:@"lato-Black" size:16]];
    /*渐变色*/
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#00BCFF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#3ACE8F"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#48DE4D"].CGColor];
    gradientLayer.locations = @[@0.1, @0.6, @0.9];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = self.startWorkoutBtn.bounds;
    [self.startWorkoutBtn.layer insertSublayer:gradientLayer atIndex:0];
    [self addSubview:self.startWorkoutBtn];
}

@end
