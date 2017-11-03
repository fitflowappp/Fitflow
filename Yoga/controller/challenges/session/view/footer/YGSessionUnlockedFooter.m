//
//  YGSessionUnlockedFooter.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "UIColor+Extension.h"
#import "YGSessionUnlockedFooter.h"

@implementation YGSessionUnlockedFooter
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSessionUnlockFooter];
    }
    return self;
}
-(void)setSessionUnlockFooter{
    CGFloat margin = 16*SCALE;
    self.backgroundColor = [UIColor whiteColor];
    self.playVedioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playVedioBtn.frame = CGRectMake(margin,margin,self.frame.size.width-margin*2,self.frame.size.height-margin*2);
    self.playVedioBtn.layer.masksToBounds = YES;
    self.playVedioBtn.layer.cornerRadius = self.playVedioBtn.frame.size.height/2;
    [self.playVedioBtn setTitle:@"PLAY VIDEO" forState:UIControlStateNormal];
    [self.playVedioBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.playVedioBtn.titleLabel setFont:[UIFont fontWithName:@"lato-Black" size:16*SCALE]];
    /*渐变色*/
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#00BCFF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#3ACE8F"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#48DE4D"].CGColor];
    gradientLayer.locations = @[@0.1, @0.6, @0.9];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = self.playVedioBtn.bounds;
    [self.playVedioBtn.layer insertSublayer:gradientLayer atIndex:0];
    [self addSubview:self.playVedioBtn];
}

@end
