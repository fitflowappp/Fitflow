//
//  YGChosenChallengeFooter.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGChosenChallengeFooter.h"
@implementation YGChosenChallengeFooter
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setChosenChallengeFooter];
    }
    return self;
}
-(void)setChosenChallengeFooter{
    self.backgroundColor = [UIColor whiteColor];
    self.choosenChallengeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.choosenChallengeBtn.frame = CGRectMake(16*SCALE,16*SCALE,self.frame.size.width-32*SCALE,self.frame.size.height-32*SCALE);
    self.choosenChallengeBtn.layer.masksToBounds = YES;
    self.choosenChallengeBtn.layer.cornerRadius = self.choosenChallengeBtn.frame.size.height/2;
    [self.choosenChallengeBtn setTitle:@"CHOOSE THIS CHALLENGE" forState:UIControlStateNormal];
    [self.choosenChallengeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.choosenChallengeBtn.titleLabel setFont:[UIFont fontWithName:@"lato-Black" size:16*SCALE]];
    /*渐变色*/
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#00BCFF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#3ACE8F"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#48DE4D"].CGColor];
    gradientLayer.locations = @[@0.1, @0.6, @0.9];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = self.choosenChallengeBtn.bounds;
    [self.choosenChallengeBtn.layer insertSublayer:gradientLayer atIndex:0];
    [self addSubview:self.choosenChallengeBtn];
}
@end
