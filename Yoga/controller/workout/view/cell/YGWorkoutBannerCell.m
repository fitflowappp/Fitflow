//
//  YGWorkoutBannerCell.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGWorkoutBannerCell.h"
#import "UIImageView+AFNetworking.h"
@interface  YGWorkoutBannerCell ()
@property (nonatomic,strong) UIView *darkv;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UIImageView *challengeCoverImgv;
@end

@implementation YGWorkoutBannerCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setChallengeCell];
    }
    return self;
}

-(void)setChallengeCell{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:10];
    [self addChallengeCoverImgv];
    [self addDarkv];
    [self addTitleLabel];
    [self addSubtitleLabel];
}

-(void)addChallengeCoverImgv{
    self.challengeCoverImgv = [[UIImageView alloc] initWithFrame:self.bounds];
    self.challengeCoverImgv.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.challengeCoverImgv];
}

-(void)addDarkv{
    self.darkv = [[UIView alloc] initWithFrame:self.challengeCoverImgv.bounds];
    self.darkv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.challengeCoverImgv addSubview:self.darkv];
}

-(void)addTitleLabel{
    CGFloat centerY = self.frame.size.height/2;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(0,centerY-4*SCALE-29*SCALE,self.frame.size.width,29*SCALE);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:24*SCALE];
    [self addSubview:self.titleLabel];
}

-(void)addSubtitleLabel{
    CGFloat centerY = self.frame.size.height/2;
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.frame = CGRectMake(0,centerY+4*SCALE,self.frame.size.width,17*SCALE);
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14*SCALE];
    [self addSubview:self.subTitleLabel];
}

-(void)setChallenge:(YGChallenge *)challenge{
    if (challenge!=_challenge) {
        _challenge = challenge;
        self.titleLabel.text = challenge.title;
        self.subTitleLabel.text = challenge.subTitle;
        [self.challengeCoverImgv setImageWithURL:[NSURL URLWithString:challenge.coverImg.coverUrl] placeholderImage:nil];
    }
    if (challenge==nil) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
}
@end
