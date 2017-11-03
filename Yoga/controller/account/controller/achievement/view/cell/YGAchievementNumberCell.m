//
//  YGAchievementNumberCell.m
//  Yoga
//
//  Created by lyj on 2017/10/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGAchievementNumberCell.h"

@interface YGAchievementNumberCell ()
@property (nonatomic,strong) UIView  *linev;
@property (nonatomic,strong) UILabel *numberLabel;
@end

@implementation YGAchievementNumberCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAchievementNumberCell];
    }
    return self;

}

-(void)setAchievementNumberCell{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10.0f;
    self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    self.layer.borderColor = [UIColor colorWithHexString:@"#ECECEC"].CGColor;
    self.layer.borderWidth = 1;
    self.layer.shadowRadius = 8;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeMake(0,-2);
    [self addLinev];
    [self addNumberLabel];
}

-(void)addNumberLabel{
    self.numberLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.numberLabel.adjustsFontSizeToFitWidth = YES;
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.font = [UIFont fontWithName:@"Lato-Black" size:40];
    self.numberLabel.textColor = [UIColor colorWithHexString:@"#0EC07F"];
    [self addSubview:self.numberLabel];
}

-(void)addLinev{
    self.linev = [[UIView alloc] initWithFrame:CGRectMake(0,(self.frame.size.height-1)/2,self.frame.size.width,1)];
    self.linev.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    [self addSubview:self.linev];
}

-(void)setNumber:(NSString *)number{
    if (number!=_number) {
        _number = number;
        self.numberLabel.text = number;
    }

}
@end
