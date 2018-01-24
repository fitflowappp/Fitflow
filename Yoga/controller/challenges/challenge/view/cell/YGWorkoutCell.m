//
//  YGChallengeSessionCell.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGWorkoutCell.h"

@interface YGWorkoutCell ()
@property (nonatomic,strong) UIView *dotv1;
@property (nonatomic,strong) UIView *dotv2;
@property (nonatomic,strong) UIView *dotv3;
@property (nonatomic,strong) UIView *dotv4;
@property (nonatomic,strong) UIView *linev;
@property (nonatomic,strong) UIImageView *arrowImgv;
@property (nonatomic,strong) UILabel *durationLabel;
@property (nonatomic,strong) UILabel *sessionTitleLabel;
@property (nonatomic,strong) UILabel *sesstionIndexLabel;
@property (nonatomic,strong) UIImageView *sessionFinishImgv;
@end

@implementation YGWorkoutCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setChallengeSessionCell];
    }
    return self;
}

-(void)setChallengeSessionCell{
    [self addLinev];
    [self addArrowImgv];
    [self addSessionIndexLabel];
    [self addSessionFinishImgv];
    [self addDurationLabel];
    [self addSessionTitleLabel];
    [self setdotv];
    [self setBackgroundColor:[UIColor clearColor]];
}

-(void)addLinev{
    CGFloat margin = self.frame.size.height/2+8+16;
    self.linev = [[UIView alloc] initWithFrame:CGRectMake(margin,self.frame.size.height-1,self.frame.size.width-margin-16,1)];
    self.linev.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    [self addSubview:self.linev];
}

-(void)addArrowImgv{
    self.arrowImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
    self.arrowImgv.center = CGPointMake(self.frame.size.width-self.arrowImgv.frame.size.width/2-16,(self.frame.size.height)/2);
    [self addSubview:self.arrowImgv];
}

-(void)addSessionIndexLabel{
    CGFloat diamter = self.frame.size.height/2.0;
    self.sesstionIndexLabel = [[UILabel alloc] init];
    self.sesstionIndexLabel.frame = CGRectMake(16,(self.frame.size.height-diamter)/2,diamter,diamter);
    self.sesstionIndexLabel.backgroundColor = [UIColor whiteColor];
    self.sesstionIndexLabel.layer.masksToBounds = YES;
    self.sesstionIndexLabel.layer.cornerRadius = diamter/2.0;
    self.sesstionIndexLabel.layer.borderWidth = 2;
    self.sesstionIndexLabel.textAlignment = NSTextAlignmentCenter;
    self.sesstionIndexLabel.font = [UIFont fontWithName:@"Lato-Black" size:14];
    self.sesstionIndexLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    self.sesstionIndexLabel.layer.borderColor = [UIColor colorWithHexString:@"#ECECEC"].CGColor;
    [self addSubview:self.sesstionIndexLabel];
}

-(void)addSessionFinishImgv{
    CGFloat diamter = self.sesstionIndexLabel.frame.size.height-4;
    self.sessionFinishImgv = [[UIImageView alloc] initWithFrame:CGRectMake(2,2,diamter,diamter)];
    self.sessionFinishImgv.image = [UIImage imageNamed:@"right-white"];
    self.sessionFinishImgv.hidden = YES;
    [self.sesstionIndexLabel addSubview:self.sessionFinishImgv];
}

-(void)addDurationLabel{
    CGFloat marginX = self.arrowImgv.frame.origin.x-12-56;
    self.durationLabel = [[UILabel alloc] init];
    self.durationLabel.frame = CGRectMake(marginX,0,56,self.frame.size.height);
    self.durationLabel.textAlignment = NSTextAlignmentRight;
    self.durationLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    self.durationLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    [self addSubview:self.durationLabel];
}

-(void)addSessionTitleLabel{
    self.sessionTitleLabel = [[UILabel alloc] init];
    self.sessionTitleLabel.frame = CGRectMake(self.linev.frame.origin.x,0,self.durationLabel.frame.origin.x-self.linev.frame.origin.x-22,self.frame.size.height);
    self.sessionTitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.sessionTitleLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    [self addSubview:self.sessionTitleLabel];
}

-(void)setdotv{
    
    CGFloat distance = (self.frame.size.height/2.0-16)/5.0;
    
    CGFloat sessionIndexY = self.sesstionIndexLabel.frame.origin.y;
    CGFloat sessionIndexMaxY = CGRectGetMaxY(self.sesstionIndexLabel.frame);
    self.dotv2 = [self getDotv];
    self.dotv2.hidden = YES;
    self.dotv2.center = CGPointMake(self.sesstionIndexLabel.center.x,sessionIndexY-distance-self.dotv2.frame.size.height/2);
    
    self.dotv1 = [self getDotv];
    self.dotv1.hidden = YES;
    self.dotv1.center = CGPointMake(self.sesstionIndexLabel.center.x,self.dotv2.frame.origin.y-distance-self.dotv1.frame.size.height/2);
    [self addSubview:self.dotv1];
    
    [self addSubview:self.dotv2];
    self.dotv3 = [self getDotv];
    self.dotv3.center = CGPointMake(self.sesstionIndexLabel.center.x,sessionIndexMaxY+distance+self.dotv3.frame.size.height/2);
    [self addSubview:self.dotv3];
    self.dotv4 = [self getDotv];
    self.dotv4.center = CGPointMake(self.sesstionIndexLabel.center.x,CGRectGetMaxY(self.dotv3.frame)+distance+self.dotv4.frame.size.height/2);
    [self addSubview:self.dotv4];
}

-(UIView*)getDotv{
    UIView *dotv = [[UIView alloc] initWithFrame:CGRectMake(0,0,4,4)];
    dotv.layer.masksToBounds = YES;
    dotv.layer.masksToBounds = YES;
    dotv.layer.cornerRadius = dotv.frame.size.height/2;
    dotv.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    return dotv;
}

-(void)setWorkoutIndex:(NSInteger)workoutIndex{
    if (workoutIndex!=_workoutIndex) {
        _workoutIndex = workoutIndex;
        self.sesstionIndexLabel.text = [NSString stringWithFormat:@"%ld",(long)workoutIndex];
    }
}

-(void)setIsMineChallengeWorkout:(BOOL)isMineChallengeWorkout{
    if (isMineChallengeWorkout!=_isMineChallengeWorkout) {
        _isMineChallengeWorkout = isMineChallengeWorkout;
    }
}
-(void)setWorkout:(YGSession *)workout{
    if (workout!=_workout) {
        _workout = workout;
        self.sessionTitleLabel.text = workout.title;
        self.durationLabel.text = [NSString stringWithFormat:@"%@ mins",workout.duration];
        if (self.isMineChallengeWorkout==YES) {
            NSNumber *sessionStatus = workout.status;
            if (workout.avail.boolValue) {
                self.sesstionIndexLabel.textColor = [UIColor colorWithHexString:@"#0EC07F"];
                self.sesstionIndexLabel.layer.borderColor = [UIColor colorWithHexString:@"#41D395"].CGColor;
                self.sessionTitleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
                self.durationLabel.textColor = [UIColor colorWithHexString:@"#000000"];
            }else{
                self.sesstionIndexLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
                self.sesstionIndexLabel.layer.borderColor = [UIColor colorWithHexString:@"#ECECEC"].CGColor;
                self.sessionTitleLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
                self.durationLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
            }
            if (sessionStatus.intValue>2) {
                self.sessionFinishImgv.hidden = NO;
            }else{
                self.sessionFinishImgv.hidden = YES;
            }
            
        }
    }
}

-(void)setWorkoutIndexType:(WORKOUT_INDEX_TYPE)workoutIndexType{
    if (workoutIndexType !=_workoutIndexType) {
        _workoutIndexType = workoutIndexType;
        switch (workoutIndexType) {
            case WORKOUT_INDEX_TOP:
            {
                self.dotv1.hidden = YES;
                self.dotv2.hidden = YES;
                self.dotv3.hidden = NO;
                self.dotv4.hidden = NO;
            }
                break;
            case WORKOUT_INDEX_CENTER:
            {
                self.dotv1.hidden = NO;
                self.dotv2.hidden = NO;
                self.dotv3.hidden = NO;
                self.dotv4.hidden = NO;
            }
                break;
            case WORKOUT_INDEX_BOTTOM:
            {
                self.dotv1.hidden = NO;
                self.dotv2.hidden = NO;
                self.dotv3.hidden = YES;
                self.dotv4.hidden = YES;
                
            }
                break;
            case WORKOUT_INDEX_ONLY_ONE:
            {
                self.dotv1.hidden = YES;
                self.dotv2.hidden = YES;
                self.dotv3.hidden = YES;
                self.dotv4.hidden = YES;
            }
                break;
                
            default:
                break;
        }
    }
}
@end
