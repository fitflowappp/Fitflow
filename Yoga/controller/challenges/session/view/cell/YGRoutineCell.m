//
//  YogaRoutineCell.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGRoutineCell.h"

@interface YGRoutineCell ()

//@property (nonatomic,strong) UIView  *linev;
@property (nonatomic,strong) UIView *dotv1;
@property (nonatomic,strong) UIView *dotv2;
@property (nonatomic,strong) UIView *dotv3;
@property (nonatomic,strong) UIView *dotv4;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *routineIndexLabel;
//@property (nonatomic,strong) UILabel *routineTimeLabel;

@end

@implementation YGRoutineCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setRoutinCell];
    }
    return self;
}

-(void)setRoutinCell{
    [self addTitleLabel];
    [self addRoutineIndexLabel];
    [self addDotv];
}

-(void)addRoutineIndexLabel{
    int diamter = (int)self.frame.size.height/2;
    self.routineIndexLabel = [[UILabel alloc] init];
    self.routineIndexLabel.frame = CGRectMake(0,(self.frame.size.height-diamter)/2,diamter,diamter);
    self.routineIndexLabel.backgroundColor = [UIColor whiteColor];
    self.routineIndexLabel.layer.masksToBounds = YES;
    self.routineIndexLabel.layer.cornerRadius = diamter/2.0;
    self.routineIndexLabel.layer.borderWidth = 2;
    self.routineIndexLabel.textAlignment = NSTextAlignmentCenter;
    self.routineIndexLabel.font = [UIFont fontWithName:@"Lato-Black" size:14*SCALE];
    self.routineIndexLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    self.routineIndexLabel.layer.borderColor = [UIColor colorWithHexString:@"#ECECEC"].CGColor;
    [self addSubview:self.routineIndexLabel];
}

-(void)addTitleLabel{
    CGFloat margin = self.frame.size.height/2+8*SCALE;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(margin,0,self.frame.size.width-margin,self.frame.size.height);
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16*SCALE];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    [self addSubview:self.titleLabel];
}

-(void)addDotv{
    CGFloat sessionIndexY = self.routineIndexLabel.frame.origin.y;
    CGFloat sessionIndexMaxY = CGRectGetMaxY(self.routineIndexLabel.frame);
    self.dotv2 = [self getDotv];
    self.dotv2.hidden = YES;
    self.dotv2.center = CGPointMake(self.routineIndexLabel.center.x,sessionIndexY-4*SCALE-self.dotv2.frame.size.height/2);
    
    self.dotv1 = [self getDotv];
    self.dotv1.hidden = YES;
    self.dotv1.center = CGPointMake(self.routineIndexLabel.center.x,self.dotv2.frame.origin.y-3*SCALE-self.dotv1.frame.size.height/2);
    [self addSubview:self.dotv1];
    
    [self addSubview:self.dotv2];
    self.dotv3 = [self getDotv];
    self.dotv3.center = CGPointMake(self.routineIndexLabel.center.x,sessionIndexMaxY+4*SCALE+self.dotv3.frame.size.height/2);
    [self addSubview:self.dotv3];
    self.dotv4 = [self getDotv];
    self.dotv4.center = CGPointMake(self.routineIndexLabel.center.x,CGRectGetMaxY(self.dotv3.frame)+3*SCALE+self.dotv4.frame.size.height/2);
    [self addSubview:self.dotv4];
}

-(UIView*)getDotv{
    UIView *dotv = [[UIView alloc] initWithFrame:CGRectMake(0,0,4*SCALE,4*SCALE)];
    dotv.layer.masksToBounds = YES;
    dotv.layer.masksToBounds = YES;
    dotv.layer.cornerRadius = dotv.frame.size.height/2;
    dotv.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    return dotv;
}

-(void)setRoutineIndex:(NSInteger)routineIndex{
    if (routineIndex!=_routineIndex) {
        _routineIndex = routineIndex;
        self.routineIndexLabel.text = [NSString stringWithFormat:@"%ld",(long)routineIndex];
    }
}

-(void)setRoutine:(YGRoutine *)routine{
    if (routine!=_routine) {
        _routine = routine;
        self.titleLabel.text = routine.title;
    }
}

-(void)setRoutineIndexType:(ROUTINE_INDEX_TYPE)routineIndexType{
    if (routineIndexType !=_routineIndexType) {
        _routineIndexType = routineIndexType;
        switch (routineIndexType) {
            case ROUTINE_INDEX_TOP:
            {
                self.dotv1.hidden = YES;
                self.dotv2.hidden = YES;
                self.dotv3.hidden = NO;
                self.dotv4.hidden = NO;
            }
                break;
            case ROUTINE_INDEX_CENTER:
            {
                self.dotv1.hidden = NO;
                self.dotv2.hidden = NO;
                self.dotv3.hidden = NO;
                self.dotv4.hidden = NO;
            }
                break;
            case ROUTINE_INDEX_BOTTOM:
            {
                self.dotv1.hidden = NO;
                self.dotv2.hidden = NO;
                self.dotv3.hidden = YES;
                self.dotv4.hidden = YES;
                
            }
                break;
            case ROUTINE_INDEX_ONLY_ONE:
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
