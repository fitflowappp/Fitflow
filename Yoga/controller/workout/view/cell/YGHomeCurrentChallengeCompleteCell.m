//
//  YGHomeCurrentChallengeCompleteCell.m
//  Yoga
//
//  Created by lyj on 2018/1/10.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGHomeCurrentChallengeCompleteCell.h"
#import "UIColor+Extension.h"
#import "UIImageView+AFNetworking.h"
@interface YGHomeCurrentChallengeCompleteCell ()
@property (nonatomic,strong) UIView *darkv;
@property (nonatomic,strong) UIImageView *coverImgv;
@property (nonatomic,strong) UILabel *challengeTitleLabel;
@property (nonatomic,strong) UILabel *completeInfomationLabel;
@property (nonatomic,strong) UIButton *chooseNewChallengeBtn;
@end
@implementation YGHomeCurrentChallengeCompleteCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setChallengeCell];
    }
    return self;
}

-(void)setChallengeCell{
    [self addCoverImgv];
    [self addDarkv];
    [self addChallengeTitleLabel];
    [self addChooseNewChallengeBtn];
    [self addCompleteInfomationLabel];
}

-(void)addDarkv{
    self.darkv = [[UIView alloc] initWithFrame:self.bounds];
    self.darkv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:self.darkv];
}

-(void)addCoverImgv{
    self.coverImgv = [[UIImageView alloc] initWithFrame:self.bounds];
    self.coverImgv.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImgv.clipsToBounds = YES;
    [self addSubview:self.coverImgv];
}

-(void)addChallengeTitleLabel{
    CGFloat marginY = (38/219.0)*self.frame.size.height;
    self.challengeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,marginY,self.frame.size.width-32,(28/219.0)*self.frame.size.height)];
    self.challengeTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.challengeTitleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:20];
    self.challengeTitleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:self.challengeTitleLabel];
}

-(void)addCompleteInfomationLabel{
    CGFloat marginY = CGRectGetMaxY(self.challengeTitleLabel.frame)-4;
    CGFloat height = self.chooseNewChallengeBtn.frame.origin.y-marginY;
    self.completeInfomationLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,marginY,self.frame.size.width-32,height)];
    self.completeInfomationLabel.numberOfLines = 0;
    self.completeInfomationLabel.textAlignment = NSTextAlignmentCenter;
    self.completeInfomationLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    self.completeInfomationLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:self.completeInfomationLabel];
}

-(void)addChooseNewChallengeBtn{
    CGFloat marginY = self.frame.size.height -42-32;
    self.chooseNewChallengeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chooseNewChallengeBtn.frame = CGRectMake((self.frame.size.width-212)/2,marginY,212,32);
    self.chooseNewChallengeBtn.layer.masksToBounds = YES;
    self.chooseNewChallengeBtn.layer.borderWidth = 0.5;
    self.chooseNewChallengeBtn.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
    self.chooseNewChallengeBtn.layer.cornerRadius = self.chooseNewChallengeBtn.frame.size.height/2;
    [self.chooseNewChallengeBtn setTitle:@"CHOOSE NEW CHALLENGE" forState:UIControlStateNormal];
    [self.chooseNewChallengeBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.chooseNewChallengeBtn.titleLabel setFont:[UIFont fontWithName:@"lato-Bold" size:14]];
    self.chooseNewChallengeBtn.backgroundColor = [UIColor clearColor];
    [self.chooseNewChallengeBtn addTarget:self action:@selector(didSelelctChooseNewChallengeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.chooseNewChallengeBtn];
}

-(void)setChallenge:(YGChallenge *)challenge{
    if (challenge!=_challenge) {
        _challenge = challenge;
        self.challengeTitleLabel.text = [challenge.title uppercaseString];
        [self.coverImgv setImage: [UIImage imageNamed:@"Challenge-Complete.jpg"]];
        self.completeInfomationLabel.text = @"You have completed this challenge!\nTo replay any class from this challenge,\ngo to the Discover tab.";
    }
}

-(void)didSelelctChooseNewChallengeBtn{
    [self.delegate didSelectChooseNewChallangeInHomeCompleteChallengeCell];
}

@end
