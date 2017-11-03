//
//  YGCurrentChallengeCell.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGCurrentChallengeCell.h"
#import "UIImageView+AFNetworking.h"
@interface YGCurrentChallengeCell ()

@property (nonatomic,strong) UIImageView *challengeStarImgv;

@property (nonatomic,strong) UIImageView *challengeCoverImgv;

@property (nonatomic,strong) UIView *darkv;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *subTitleLabel;

@end

@implementation YGCurrentChallengeCell

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
    [self setBackgroundColor:[UIColor clearColor]];
}

-(void)addDarkv{
    self.darkv = [[UIView alloc] initWithFrame:self.challengeCoverImgv.bounds];
    self.darkv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.challengeCoverImgv addSubview:self.darkv];
}

-(void)addChallengeStarImgv{
    self.challengeStarImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"current"]];
    self.challengeStarImgv.center = CGPointMake(self.frame.size.width-self.challengeStarImgv.frame.size.width/2-17,self.challengeStarImgv.frame.size.height/2);
    [self addSubview:self.challengeStarImgv];
}

-(void)addChallengeCoverImgv{
    self.challengeCoverImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0,4,self.frame.size.width,self.frame.size.height-4)];
    self.challengeCoverImgv.contentMode = UIViewContentModeScaleAspectFill;
    self.challengeCoverImgv.layer.masksToBounds = YES;
    self.challengeCoverImgv.layer.cornerRadius = 10;
    [self addSubview:self.challengeCoverImgv];
}

-(void)addTitleLabel{
    CGFloat centerY = self.challengeCoverImgv.frame.size.height/2;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(0,centerY-4-29,self.frame.size.width,29);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:24];
    [self.challengeCoverImgv addSubview:self.titleLabel];
}

-(void)addSubTitleLabel{
    CGFloat centerY = self.challengeCoverImgv.frame.size.height/2;
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.frame = CGRectMake(0,centerY+4,self.frame.size.width,19);
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    [self.challengeCoverImgv addSubview:self.subTitleLabel];
}

-(void)setCurrentChallenge:(YGChallenge *)currentChallenge{
    if (currentChallenge!=_currentChallenge) {
        _currentChallenge = currentChallenge;
        self.titleLabel.text = currentChallenge.title;
        self.subTitleLabel.text = currentChallenge.subTitle;
        [self.challengeCoverImgv setImageWithURL:[NSURL URLWithString:currentChallenge.coverImg.coverUrl] placeholderImage:nil];
    }
    if (!currentChallenge) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
}
@end
