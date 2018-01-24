//
//  YGDiscoverOptionView.m
//  Yoga
//
//  Created by lyj on 2018/1/2.
//  Copyright © 2018年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGDiscoverOptionView.h"
@interface YGDiscoverOptionView ()
@property (nonatomic,strong) UIView   *optionLinev;
@end
@implementation YGDiscoverOptionView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSuviews];
    }
    return self;
}

-(void)setUpSuviews{
    self.backgroundColor = [UIColor whiteColor];
    [self addChallengesBtn];
    [self addSinglesBtn];
    [self addOptionLinev];
    
}

-(void)addChallengesBtn{
    CGFloat marginX = 48;
    CGFloat width   = (self.frame.size.width-96-39)/2;
    CGFloat height  = 16;
    self.challengesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.challengesBtn.frame = CGRectMake(marginX,0,width,height);
    [self.challengesBtn setTitle:@"Challenges" forState:UIControlStateNormal];
    [self.challengesBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [self.challengesBtn setTitleColor:[UIColor colorWithHexString:@"#7B7B7B"] forState:UIControlStateNormal];
    [self.challengesBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateSelected];
    self.challengesBtn.selected = YES;
    [self addSubview:self.challengesBtn];
}

-(void)addSinglesBtn{
    CGFloat marginX = CGRectGetMaxX(self.challengesBtn.frame)+39;
    CGFloat width   = (self.frame.size.width-96-39)/2;
    CGFloat height  = 16;
    self.singlesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.singlesBtn.frame = CGRectMake(marginX,0,width,height);
    [self.singlesBtn setTitle:@"Singles" forState:UIControlStateNormal];
    [self.singlesBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [self.singlesBtn setTitleColor:[UIColor colorWithHexString:@"#7B7B7B"] forState:UIControlStateNormal];
    [self.singlesBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateSelected];
    [self addSubview:self.singlesBtn];
    
}

-(void)addOptionLinev{
    self.optionLinev = [[UIView alloc] initWithFrame:CGRectMake(0, 0,16,1)];
    self.optionLinev.backgroundColor = [UIColor colorWithHexString:@"#0EC07F"];
    self.optionLinev.center = CGPointMake(self.challengesBtn.center.x,self.frame.size.height-1);
    [self addSubview:self.optionLinev];
}

-(void)setOptionIndex:(int)optionIndex{
    if (optionIndex!=_optionIndex) {
        _optionIndex = optionIndex;
        CGFloat optionCenterX;
        if (optionIndex==0) {
            self.challengesBtn.selected = YES;
            self.singlesBtn.selected = NO;
            optionCenterX = self.challengesBtn.center.x;
        }else{
            self.challengesBtn.selected = NO;
            self.singlesBtn.selected = YES;
            optionCenterX = self.singlesBtn.center.x;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.optionLinev.center = CGPointMake(optionCenterX,self.optionLinev.center.y);
        }];
    }
}
@end
