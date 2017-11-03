//
//  YGChallengeBannerCell.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGChallengeBannerCell.h"
#import "UIImageView+AFNetworking.h"
@interface  YGChallengeBannerCell ()

@property (nonatomic,strong) UIImageView *challengeCoverImgv;

@property (nonatomic,strong) UIView  *darkv;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *subTitleLabel;

@property (nonatomic,strong) UIImageView *lockedImgv;

@end

@implementation YGChallengeBannerCell

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
    [self addSubTitleLabel];
    [self addLockedImgv];
}

-(void)addChallengeCoverImgv{
    self.challengeCoverImgv = [[UIImageView alloc] initWithFrame:self.bounds];
    self.challengeCoverImgv.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.challengeCoverImgv];
}

-(void)addDarkv{
    self.darkv = [[UIView alloc] initWithFrame:self.challengeCoverImgv.bounds];
    [self.challengeCoverImgv addSubview:self.darkv];
}

-(void)addTitleLabel{
    CGFloat centerY = self.frame.size.height/2;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(0,centerY-4-29,self.frame.size.width,29);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:24];
    [self addSubview:self.titleLabel];
}

-(void)addSubTitleLabel{
    CGFloat centerY = self.frame.size.height/2;
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.frame = CGRectMake(0,centerY+4,self.frame.size.width,17);
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    [self addSubview:self.subTitleLabel];
}

-(void)addLockedImgv{
    self.lockedImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lock-w"]];
    self.lockedImgv.center = CGPointMake(self.frame.size.width/2,CGRectGetMaxY(self.subTitleLabel.frame)+22+self.lockedImgv.frame.size.height/2);
    [self addSubview:self.lockedImgv];
}

-(void)setChallenge:(YGChallenge *)challenge{
    if (challenge!=_challenge) {
        _challenge = challenge;
        self.titleLabel.text = challenge.title;
        self.subTitleLabel.text = challenge.subTitle;
        [self.challengeCoverImgv setImageWithURL:[NSURL URLWithString:challenge.coverImg.coverUrl] placeholderImage:nil];
    }
}

-(void)setShouldLight:(BOOL)shouldLight{
    self.lockedImgv.hidden = shouldLight;
    self.darkv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:shouldLight?0.3:0.45];
}
@end
