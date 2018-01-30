//
//  YGSessionShareLockView.m
//  Yoga
//
//  Created by 何侨 on 2018/1/29.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGSessionShareLockView.h"
#import "UIColor+Extension.h"
@implementation YGSessionShareLockView
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
    [self.playVedioBtn setTitle:@"SHARE TO UNLOCK" forState:UIControlStateNormal];
    [self.playVedioBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.playVedioBtn.titleLabel setFont:[UIFont fontWithName:@"lato-Bold" size:14]];
    self.playVedioBtn.backgroundColor = [UIColor colorWithHexString:@"#41D395"];
    [self addSubview:self.playVedioBtn];
}

- (void)setIsComplete:(BOOL)isComplete
{
    _isComplete = isComplete;
    if (_isComplete) {
        [self.playVedioBtn setTitle:@"UNLOCK THIS SINGLE" forState:UIControlStateNormal];
    }
}

@end
