//
//  YGHomeCurrentChallengeCell.m
//  Yoga
//
//  Created by lyj on 2018/1/3.
//  Copyright © 2018年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "UIImageView+AFNetworking.h"
#import "YGHomeCurrentChallengeCell.h"
@interface YGHomeCurrentChallengeCell ()
@property (nonatomic,strong) UIView *darkv;
@property (nonatomic,strong) UIImageView *coverImgv;
@property (nonatomic,strong) UILabel *workoutTitleLabel;
@property (nonatomic,strong) UILabel *workoutDurationLabel;
@property (nonatomic,strong) UILabel *workoutInfomationLabel;
@property (nonatomic,strong) UIView  *beginBkView;
@property (nonatomic,strong) UILabel *beginLabel;
@property (nonatomic,strong) UIImageView *beginImv;
@end
@implementation YGHomeCurrentChallengeCell
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
    [self addWorkoutTitleLabel];
    [self addWorkoutDurationLabel];
    [self addBeginBkView];
    [self addWorkoutInfomationLabel];
    [self addBeginImv];
    [self addBeginLabel];
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

-(void)addWorkoutTitleLabel{
    CGFloat marginY = (38/219.0)*self.frame.size.height;
    self.workoutTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,marginY,self.frame.size.width-32,(28/219.0)*self.frame.size.height)];
    self.workoutTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.workoutTitleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:20];
    self.workoutTitleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:self.workoutTitleLabel];
}

-(void)addWorkoutDurationLabel{
    self.workoutDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,CGRectGetMaxY(self.workoutTitleLabel.frame),self.frame.size.width-32,(22/219.0)*self.frame.size.height)];
    self.workoutDurationLabel.textAlignment = NSTextAlignmentCenter;
    self.workoutDurationLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    self.workoutDurationLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:self.workoutDurationLabel];
}

-(void)addBeginBkView{
    CGFloat witdh = (88/375.0)*self.frame.size.width;
    CGFloat marginX = (self.frame.size.width-witdh)/2;
    CGFloat marginY = self.frame.size.height-(32/219.0)*self.frame.size.height-(42/219.0)*self.frame.size.height;
    self.beginBkView = [[UIView alloc] initWithFrame:CGRectMake(marginX, marginY,witdh,(32/219.0)*self.frame.size.height)];
    self.beginBkView.layer.masksToBounds = YES;
    self.beginBkView.layer.cornerRadius = self.beginBkView.frame.size.height/2.0;
    self.beginBkView.backgroundColor = [UIColor colorWithHexString:@"#41D395"];
    [self addSubview:self.beginBkView];
    [self.beginBkView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectPlay)]];
}

-(void)addWorkoutInfomationLabel{
    CGFloat height = (34/219.0)*self.frame.size.height;
    CGFloat marginY = self.beginBkView.frame.origin.y-height-(11/219.0)*self.frame.size.height;
    self.workoutInfomationLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,marginY,self.frame.size.width-32,height)];
    self.workoutInfomationLabel.numberOfLines = 0;
    self.workoutInfomationLabel.textAlignment = NSTextAlignmentCenter;
    self.workoutInfomationLabel.font = [UIFont fontWithName:@"Lato-Regular" size:MIN(SCALE,1)*14];
    self.workoutInfomationLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:self.workoutInfomationLabel];
}

-(void)addBeginImv{
    self.beginImv = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"Singles-play"]];
    self.beginImv.center = CGPointMake(4+self.beginImv.frame.size.width/2.0,self.beginBkView.frame.size.height/2.0);
    [self.beginBkView addSubview:self.beginImv];
}

-(void)addBeginLabel{
    CGFloat marginX = (13/88.0)*self.beginBkView.frame.size.width;
    CGFloat width = (43/88.0)*self.beginBkView.frame.size.width;
    self.beginLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.beginBkView.frame.size.width-width-marginX,0,width,self.beginBkView.frame.size.height)];
    self.beginLabel.text = @"BEGIN";
    self.beginLabel.textAlignment = NSTextAlignmentCenter;
    self.beginLabel.font = [UIFont fontWithName:@"Lato-Bold" size:MIN(SCALE,1)*14];
    self.beginLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.beginBkView addSubview:self.beginLabel];
}


-(void)setChallenge:(YGChallenge *)challenge{
    if (challenge!=_challenge) {
        _challenge = challenge;
        YGSession *workout = [challenge currentWorkout];
        [self.coverImgv setImageWithURL:[NSURL URLWithString:workout.coverImg.coverUrl]];
        self.workoutTitleLabel.text = [workout.title uppercaseString];
        self.workoutDurationLabel.text = [NSString stringWithFormat:@"%@ Minutes",workout.duration];
        self.workoutInfomationLabel.text = [NSString stringWithFormat:@"Class %ld of %ld from:\n%@",[self.challenge.workoutList indexOfObject:workout]+1,self.challenge.workoutList.count,challenge.title];
    }
}

-(void)didSelectPlay{
    if ([self.delegate respondsToSelector:@selector(didSelectPlayCurrentWorkout:)]) {
        if (self.challenge) {
            YGSession *workout = [self.challenge currentWorkout];
            if (workout.routineList.count) {
                [self.delegate didSelectPlayCurrentWorkout:workout];
            }
        }
    }
}
@end
