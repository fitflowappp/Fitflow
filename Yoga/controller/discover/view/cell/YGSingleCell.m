//
//  YGSingleCell.m
//  Yoga
//
//  Created by lyj on 2018/1/3.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGSingleCell.h"
#import "UIColor+Extension.h"
#import "UIImageView+AFNetworking.h"
@interface YGSingleCell ()
@property (nonatomic,strong) UIView   *darkv;
@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic,strong) UILabel  *titleLabel;
@property (nonatomic,strong) UILabel  *subTitleLabel;
@property (nonatomic,strong) UIImageView *challengeCoverImgv;
@end
@implementation YGSingleCell
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
    [self addDarkv];
    [self addTitleLabel];
    [self addSubTitleLabel];
    [self addPlayBtn];
}

-(void)addDarkv{
    self.darkv = [[UIView alloc] initWithFrame:self.bounds];
    self.darkv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:self.darkv];
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

-(void)addPlayBtn{
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(self.frame.size.width-32-16,16,32,32);
    self.playBtn.layer.masksToBounds = YES;
    self.playBtn.layer.cornerRadius = 16;
    self.playBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.2];
    [self.playBtn setImage:[UIImage imageNamed:@"Singles-play"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(didSelectPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playBtn];
}

-(void)setWorkout:(YGSession *)workout{
    if (workout!=_workout) {
        _workout = workout;
        self.titleLabel.text = workout.title;
        self.subTitleLabel.text = [NSString stringWithFormat:@"%@ Minutes",workout.duration];
        [self.challengeCoverImgv setImageWithURL:[NSURL URLWithString:workout.coverImg.coverUrl] placeholderImage:nil];
    }
}

-(void)didSelectPlay:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(playWorkoutInSingle:)]) {
        if (self.workout.routineList.count) {
         [self.delegate playWorkoutInSingle:self.workout];
        }
    }
}
@end
