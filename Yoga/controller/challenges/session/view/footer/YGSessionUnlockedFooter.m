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
    CGFloat margin = 16;
    self.backgroundColor = [UIColor whiteColor];
    self.playVedioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playVedioBtn.frame = CGRectMake(margin,margin,self.frame.size.width-margin*2,self.frame.size.height-margin*2);
    self.playVedioBtn.layer.masksToBounds = YES;
    self.playVedioBtn.layer.cornerRadius = self.playVedioBtn.frame.size.height/2;
    [self.playVedioBtn setTitle:@"PLAY VIDEO" forState:UIControlStateNormal];
    [self.playVedioBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.playVedioBtn.titleLabel setFont:[UIFont fontWithName:@"lato-Bold" size:14]];
    self.playVedioBtn.backgroundColor = [UIColor colorWithHexString:@"#41D395"];
    [self addSubview:self.playVedioBtn];
}

@end
