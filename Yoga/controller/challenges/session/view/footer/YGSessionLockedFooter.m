//
//  YGSessionFooter.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGSessionLockedFooter.h"

@implementation YGSessionLockedFooter
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSessionLockedFooter];
    }
    return self;
}
-(void)setSessionLockedFooter{
    CGFloat margin = 16*SCALE;
    self.backgroundColor = [UIColor whiteColor];
    self.startChallengeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startChallengeBtn.frame = CGRectMake(margin,margin,self.frame.size.width-margin*2,self.frame.size.height-margin*2);
    self.startChallengeBtn.layer.masksToBounds = YES;
    self.startChallengeBtn.layer.cornerRadius = self.startChallengeBtn.frame.size.height/2;
    self.startChallengeBtn.layer.borderWidth = 2.0f;
    self.startChallengeBtn.layer.borderColor = [UIColor colorWithHexString:@"#0EC07F"].CGColor;
    [self.startChallengeBtn setTitle:@"UNLOCK WORKOUT" forState:UIControlStateNormal];
    [self.startChallengeBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
    [self.startChallengeBtn.titleLabel setFont:[UIFont fontWithName:@"lato-Black" size:16*SCALE]];
    [self addSubview:self.startChallengeBtn];
}

@end
