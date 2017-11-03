//
//  YGChallengeCell.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGChallengeCell.h"
#import "UIImageView+AFNetworking.h"
@interface YGChallengeCell ()

@property (nonatomic,strong) UIView  *darkv;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *subTitleLabel;

@property (nonatomic,strong) UIImageView *challengeStarImgv;

@property (nonatomic,strong) UIImageView *challengeCoverImgv;

@property (nonatomic,strong) UIImageView *completedIcomImgv;

@end

@implementation YGChallengeCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setChallengeCell];
    }
    return self;
}

-(void)setChallengeCell{
    [self addChallengeCoverImgv];
    [self addDarkv];
    [self addChallengeStarImgv];
    [self addCompletedIconImgv];
    [self addTitleLabel];
    [self addSubTitleLabel];
    [self setBackgroundColor:[UIColor clearColor]];
}

-(void)addDarkv{
    self.darkv = [[UIView alloc] initWithFrame:self.challengeCoverImgv.bounds];
    self.darkv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.challengeCoverImgv addSubview:self.darkv];
}

-(void)addChallengeStarImgv{
    self.challengeStarImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"current"]];
    self.challengeStarImgv.center = CGPointMake(self.frame.size.width-self.challengeStarImgv.frame.size.width/2-17*SCALE,self.challengeStarImgv.frame.size.height/2);
    [self addSubview:self.challengeStarImgv];
}

-(void)addChallengeCoverImgv{
    self.challengeCoverImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0,6,self.frame.size.width,self.frame.size.height-6)];
    self.challengeCoverImgv.contentMode = UIViewContentModeScaleAspectFill;
    self.challengeCoverImgv.layer.masksToBounds = YES;
    self.challengeCoverImgv.layer.cornerRadius = 10;
    [self addSubview:self.challengeCoverImgv];
}

-(void)addCompletedIconImgv{
    self.completedIcomImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"challenge_completed"]];
    CGFloat margin  = 8*SCALE;
    self.completedIcomImgv.center = CGPointMake(margin+self.completedIcomImgv.frame.size.width/2,margin+self.completedIcomImgv.frame.size.height/2);
    [self.challengeCoverImgv addSubview:self.completedIcomImgv];
}

-(void)addTitleLabel{
    CGFloat centerY = self.challengeCoverImgv.frame.size.height/2;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(0,centerY-4*SCALE-29*SCALE,self.frame.size.width,29*SCALE);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:24*SCALE];
    [self.challengeCoverImgv addSubview:self.titleLabel];
}

-(void)addSubTitleLabel{
    CGFloat centerY = self.challengeCoverImgv.frame.size.height/2;
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.frame = CGRectMake(0,centerY+4*SCALE,self.frame.size.width,19*SCALE);
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14*SCALE];
    [self.challengeCoverImgv addSubview:self.subTitleLabel];
}

-(void)setChallenge:(YGChallenge *)challenge{
    if (challenge!=_challenge) {
        _challenge = challenge;
        self.titleLabel.text = challenge.title;
        self.subTitleLabel.text = challenge.subTitle;
        [self.challengeCoverImgv setImageWithURL:[NSURL URLWithString:challenge.coverImg.coverUrl] placeholderImage:nil]; 
        self.challengeStarImgv.hidden = !challenge.isMineChallenge.boolValue;
        self.completedIcomImgv.hidden = challenge.status.intValue>2?NO:YES;
    }
}
@end
