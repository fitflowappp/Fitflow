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
    [self addTitleLabel];
    [self addSubTitleLabel];
    [self addCompletedIconImgv];
    [self setBackgroundColor:[UIColor clearColor]];
}

-(void)addDarkv{
    self.darkv = [[UIView alloc] initWithFrame:self.bounds];
    self.darkv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:self.darkv];
}

-(void)addChallengeStarImgv{
    self.challengeStarImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"current"]];
    self.challengeStarImgv.center = CGPointMake(self.frame.size.width-self.challengeStarImgv.frame.size.width/2-34,self.challengeStarImgv.frame.size.height/2-6);
    [self addSubview:self.challengeStarImgv];
}

-(void)addChallengeCoverImgv{
    self.challengeCoverImgv = [[UIImageView alloc] initWithFrame:self.bounds];
    self.challengeCoverImgv.contentMode = UIViewContentModeScaleAspectFill;
    self.challengeCoverImgv.clipsToBounds = YES;
    [self addSubview:self.challengeCoverImgv];
}

-(void)addCompletedIconImgv{
    self.completedIcomImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"challenge-completed"]];
    self.completedIcomImgv.center = CGPointMake(self.frame.size.width/2,CGRectGetMaxY(self.subTitleLabel.frame)+(self.frame.size.height-CGRectGetMaxY(self.subTitleLabel.frame))/2-4);
    [self.challengeCoverImgv addSubview:self.completedIcomImgv];
}

-(void)addTitleLabel{
    CGFloat centerY = self.challengeCoverImgv.frame.size.height/2;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(0,centerY-28,self.frame.size.width,28);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:20];
    [self addSubview:self.titleLabel];
}

-(void)addSubTitleLabel{
    CGFloat centerY = self.challengeCoverImgv.frame.size.height/2;
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.frame = CGRectMake(0,centerY,self.frame.size.width,22);
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    [self addSubview:self.subTitleLabel];
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
