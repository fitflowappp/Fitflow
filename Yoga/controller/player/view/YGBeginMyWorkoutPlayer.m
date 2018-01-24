//
//  YGBeginMyWorkoutPlayer.m
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGBeginMyWorkoutPlayer.h"
@interface YGBeginMyWorkoutPlayer ()
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) UIView      *darkv;
@property (nonatomic,strong) UIImageView *logoImgv;
@property (nonatomic,strong) UIImageView *openImgv;
@property (nonatomic,strong) UIButton    *beginMyworkoutBtn;
@property (nonatomic,strong) UIButton    *alreadyHaveAccountBtn;
@end
@implementation YGBeginMyWorkoutPlayer
-(id)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0,0,GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT);
        [self setPlayerUI];
    }
    return self;
}
#pragma mark playerUI
-(void)setPlayerUI{
    [self addOpenImgv];
    [self addDarkv];
    [self addLogoImgv];
    [self addBeginMyworkoutBtn];
    [self addBeginMyworkoutTipLabel];
    [self AddAlreadyHaveAccountBtn];
}

-(void)addOpenImgv{
    self.openImgv = [[UIImageView alloc] initWithFrame:self.frame];
    self.openImgv.image = [UIImage imageNamed:@"open"];
    self.openImgv.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.openImgv];
}

-(void)addDarkv{
    self.darkv = [[UIView alloc] initWithFrame:self.bounds];
    self.darkv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self addSubview:self.darkv];
}

-(void)addLogoImgv{
    self.logoImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo-w"]];
    self.logoImgv.center = CGPointMake(self.frame.size.width/2,(120.5/667.0)*self.frame.size.height+self.logoImgv.frame.size.height/2);
    [self addSubview:self.logoImgv];
}

-(void)AddAlreadyHaveAccountBtn{
    CGFloat height = (84.0/667.0)*self.frame.size.height;
    self.alreadyHaveAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.alreadyHaveAccountBtn.frame = CGRectMake(16,self.frame.size.height-height,self.frame.size.width-32,height);
    [self.alreadyHaveAccountBtn setTitle:@"I already have an account" forState:UIControlStateNormal];
    [self.alreadyHaveAccountBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
    [self.alreadyHaveAccountBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.alreadyHaveAccountBtn addTarget:self action:@selector(didSelectAlreadyHaveAccount) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.alreadyHaveAccountBtn];
}

-(void)addBeginMyworkoutBtn{
    CGFloat margin = self.frame.size.width*(16/375.0);
    CGFloat width  = self.frame.size.width*(343.0/375);
    CGFloat height = width*(44/343.0);
    CGFloat marginBottom = (84.0/667.0)*self.frame.size.height;
    self.beginMyworkoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beginMyworkoutBtn.frame = CGRectMake(margin,self.frame.size.height-marginBottom-height,self.frame.size.width-margin*2,height);
    self.beginMyworkoutBtn.layer.masksToBounds = YES;
    self.beginMyworkoutBtn.backgroundColor = [UIColor colorWithHexString:@"#41D395"];
    self.beginMyworkoutBtn.layer.cornerRadius = self.beginMyworkoutBtn.frame.size.height/2;
    [self.beginMyworkoutBtn setTitle:@"START FREE YOGA CLASSES" forState:UIControlStateNormal];
    [self.beginMyworkoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.beginMyworkoutBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
    [self.beginMyworkoutBtn addTarget:self action:@selector(didSelectBeginMyworkout) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.beginMyworkoutBtn];
}

-(void)addBeginMyworkoutTipLabel{
//    UILabel *beginMyworkoutTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.beginMyworkoutBtn.frame.origin.y-124,self.frame.size.width,124)];
//    beginMyworkoutTipLabel.numberOfLines = 0;
//    beginMyworkoutTipLabel.textAlignment = NSTextAlignmentCenter;
//    beginMyworkoutTipLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    beginMyworkoutTipLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
//    beginMyworkoutTipLabel.text = @"40+ expert-guided yoga classes you can do\n anytime, anywhere. 100% free.";
//    [self addSubview:beginMyworkoutTipLabel];
}

-(void)didSelectAlreadyHaveAccount{
    [self.delegate login];
}

-(void)didSelectBeginMyworkout{
    [self.delegate beginMyWorkout];
}
@end
