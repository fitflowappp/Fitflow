//
//  YogaRoutineCell.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGRoutineCell.h"
#import "UIImageView+AFNetworking.h"
@interface YGRoutineCell ()
@property (nonatomic,strong) UIView  *linev;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *coverImgv;
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
    [self addLinev];
    [self addCoverImgv];
    [self addTitleLabel];
}

-(void)addLinev{
    self.linev = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-1,self.frame.size.width,1)];
    self.linev.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    [self addSubview:self.linev];
}

-(void)addCoverImgv{
    CGFloat height = self.frame.size.height*(56/72.0);
    CGFloat witdh = height*(88/56.0);
    self.coverImgv = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-witdh-16,(self.frame.size.height-1-height)/2.0,witdh,height)];
    self.coverImgv.clipsToBounds = YES;
    self.coverImgv.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.coverImgv];
}

-(void)addTitleLabel{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(16,0,self.coverImgv.frame.origin.x-16,self.frame.size.height);
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    [self addSubview:self.titleLabel];
}
-(void)setRoutine:(YGRoutine *)routine{
    if (routine!=_routine) {
        _routine = routine;
        self.titleLabel.text = routine.title;
        [self.coverImgv setImageWithURL: [NSURL URLWithString:routine.coverImg.coverUrl] placeholderImage:[UIImage imageNamed:@"Routine-cover-default.png"]];
    }
}
@end
