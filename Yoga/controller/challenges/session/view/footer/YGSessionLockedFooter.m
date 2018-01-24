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
    CGFloat margin = 16;
    self.backgroundColor = [UIColor whiteColor];
    self.startChallengeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startChallengeBtn.frame = CGRectMake(margin,margin,self.frame.size.width-margin*2,self.frame.size.height-margin*2);
    self.startChallengeBtn.layer.masksToBounds = YES;
    self.startChallengeBtn.layer.cornerRadius = self.startChallengeBtn.frame.size.height/2;
    [self.startChallengeBtn setTitle:@"UNLOCK THIS SINGLE" forState:UIControlStateNormal];
    [self.startChallengeBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.startChallengeBtn.titleLabel setFont:[UIFont fontWithName:@"lato-Bold" size:14]];
    self.startChallengeBtn.backgroundColor = [UIColor colorWithHexString:@"#41D395"];
    [self addSubview:self.startChallengeBtn];
}

@end
