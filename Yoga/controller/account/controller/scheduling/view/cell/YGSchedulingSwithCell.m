//
//  YGSchedulingSwithCell.m
//  Yoga
//
//  Created by lyj on 2017/10/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGSchedulingSwithCell.h"
@interface YGSchedulingSwithCell ()
@property (nonatomic,strong) UILabel  *titleLabel;
@end
@implementation YGSchedulingSwithCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setShedulingSwitchCell];
    }
    return self;
}

-(void)setShedulingSwitchCell{
    self.backgroundColor = [UIColor whiteColor];
    [self addLinev];
    [self addSwitchBtn];
    [self addTitleLabel];
}

-(void)addLinev{
    self.linev = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-1,self.frame.size.width,1)];
    self.linev.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    [self addSubview:self.linev];
    
}

-(void)addTitleLabel{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(0,0,self.frame.size.width-self.switchBtn.frame.size.width-5,self.frame.size.height);
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    [self addSubview:self.titleLabel];
}

-(void)addSwitchBtn{
    self.switchBtn = [[UISwitch alloc] init];
    self.switchBtn.center = CGPointMake(self.frame.size.width-self.switchBtn.frame.size.width/2,(self.frame.size.height-1)/2);
    [self addSubview:self.switchBtn];
}

-(void)setTitleText:(NSString *)titleText{
    if (titleText!=_titleText) {
        _titleText = titleText;
        self.titleLabel.text = titleText;
    }
}
@end
