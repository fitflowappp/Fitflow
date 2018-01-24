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
    self.choosenChallengeBtn.frame = CGRectMake(16,16,self.frame.size.width-32,self.frame.size.height-32);
    self.choosenChallengeBtn.layer.masksToBounds = YES;
    self.choosenChallengeBtn.layer.cornerRadius = self.choosenChallengeBtn.frame.size.height/2;
    [self.choosenChallengeBtn setTitle:@"CHOOSE THIS CHALLENGE" forState:UIControlStateNormal];
    [self.choosenChallengeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.choosenChallengeBtn.titleLabel setFont:[UIFont fontWithName:@"lato-Black" size:14]];
    self.choosenChallengeBtn.backgroundColor = [UIColor colorWithHexString:@"#41D395"];
    [self addSubview:self.choosenChallengeBtn];
}
@end
