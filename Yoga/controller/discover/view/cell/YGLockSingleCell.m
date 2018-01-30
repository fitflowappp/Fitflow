//
//  YGLockSingleCell.m
//  Yoga
//
//  Created by 何侨 on 2018/1/29.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGLockSingleCell.h"
#import "UIColor+Extension.h"
#import "UIImageView+AFNetworking.h"
#import "YGSession.h"

@interface YGLockSingleCell ()
@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic,strong) UILabel  *titleLabel;
@property (nonatomic,strong) UILabel  *subTitleLabel;
@property (nonatomic,strong) UIImageView *challengeCoverImgv;
@end

@implementation YGLockSingleCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setChallengeCell];
    }
    return self;
}

-(void)setChallengeCell{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    [self addChallengeCoverImgv];
    [self addLock];
    [self addTitleLabel];
    [self addSubTitleLabel];
    [self addLockImage];
}

-(void)addLock{
    CALayer *lockBGlayer = [[CALayer alloc] init];
    lockBGlayer.frame = self.bounds;
    lockBGlayer.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:.6].CGColor;
    [self.layer addSublayer:lockBGlayer];
}

-(void)addLockImage{
    UIImageView *lockImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lock-w"]];
    lockImage.center = CGPointMake(GET_SCREEN_WIDTH/2-20*SCALE, self.bounds.size.height/2);
    [self addSubview:lockImage];
}

-(void)addChallengeCoverImgv{
    self.challengeCoverImgv = [[UIImageView alloc] initWithFrame:self.bounds];
    self.challengeCoverImgv.contentMode = UIViewContentModeScaleAspectFill;
    self.challengeCoverImgv.clipsToBounds = YES;
    [self addSubview:self.challengeCoverImgv];
}

-(void)addTitleLabel{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(16,12,self.frame.size.width-32,28);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:20];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"Yoga";
}

-(void)addSubTitleLabel{
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.frame = CGRectMake(16,CGRectGetMaxY(self.titleLabel.frame),self.frame.size.width-32,22);
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    [self addSubview:self.subTitleLabel];
    self.subTitleLabel.text = @"subTitle";
}

-(void)setWorkout:(YGSession *)workout{
    if (workout!=_workout) {
        _workout = workout;
        self.titleLabel.text = workout.title;
        self.subTitleLabel.text = [NSString stringWithFormat:@"%@ Minutes",workout.duration];
        [self.challengeCoverImgv setImageWithURL:[NSURL URLWithString:workout.coverImg.coverUrl] placeholderImage:[UIImage imageNamed:@"Routine-cover-default.png"]];
    }
}

@end

