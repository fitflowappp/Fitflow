//
//  YGUnlockChallengeFooter.m
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGUnlockChallengeFooter.h"
#import "UIColor+Extension.h"
@implementation YGUnlockChallengeFooter
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUnlockChallengeFooter];
    }
    return self;
}
-(void)setUnlockChallengeFooter{
    self.backgroundColor = [UIColor whiteColor];
    self.unlockChallengeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.unlockChallengeBtn.frame = CGRectMake(16,16,self.frame.size.width-32,self.frame.size.height-32);
    self.unlockChallengeBtn.layer.masksToBounds = YES;
    self.unlockChallengeBtn.layer.cornerRadius = self.unlockChallengeBtn.frame.size.height/2;
    self.unlockChallengeBtn.layer.borderWidth = 2.0f;
    self.unlockChallengeBtn.layer.borderColor = [UIColor colorWithHexString:@"#0EC07F"].CGColor;
    [self.unlockChallengeBtn setTitle:@"UNLOCK CHALLENGE" forState:UIControlStateNormal];
    [self.unlockChallengeBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
    [self.unlockChallengeBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [self addSubview:self.unlockChallengeBtn];
}
@end
