//
//  YGOnboardingGoalCell.m
//  Yoga
//
//  Created by lyj on 2017/12/21.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGOnboardingGoalCell.h"
@interface YGOnboardingGoalCell ()
@property (nonatomic,strong) UIView      *linev;
@property (nonatomic,strong) UIImageView *arrowImgv;
@end
@implementation YGOnboardingGoalCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setOnboardingGoalCell];
    }
    return self;
}

-(void)setOnboardingGoalCell{
    [self addLineV];
    [self addNextArrowImgv];
    [self addTitleLabel];
}

-(void)addTitleLabel{
    self.titlabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.arrowImgv.frame.origin.x-8*SCALE,self.frame.size.height)];
    self.titlabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.titlabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.titlabel.numberOfLines = 0;
    [self addSubview:self.titlabel];
}

-(void)addLineV{
    self.linev = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-0.5,self.frame.size.width,0.5)];
    self.linev.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.2];
    [self addSubview:self.linev];

}

-(void)addNextArrowImgv{
    self.arrowImgv = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"next-white@3x.png"]];
    self.arrowImgv.center = CGPointMake(self.frame.size.width-8*SCALE-self.arrowImgv.frame.size.width/2,(self.frame.size.height-0.5)/2);
    [self addSubview:self.arrowImgv];
}
@end
