//
//  YGMyAchievementsHeader.m
//  Yoga
//
//  Created by lyj on 2018/1/3.
//  Copyright © 2018年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGHomeSectionHeader.h"
@interface YGHomeSectionHeader ()

@end
@implementation YGHomeSectionHeader
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#E5F9F1"];
        [self setTextLabel];
         [self setAlertTipLabel];
    }
    return self;
}

-(void)setTextLabel{
    CGFloat titleHeight = 32*SCALE;
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,titleHeight)];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    self.textLabel.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
    self.textLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    [self addSubview:self.textLabel];
}

-(void)setAlertTipLabel{
    self.alertTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(32,self.textLabel.frame.size.height,self.frame.size.width-64,self.frame.size.height-self.textLabel.frame.size.height)];
    self.alertTipLabel.textAlignment = NSTextAlignmentCenter;
    self.alertTipLabel.numberOfLines = 0;
    self.alertTipLabel.adjustsFontSizeToFitWidth = YES;
    self.alertTipLabel.textColor = [UIColor colorWithHexString:@"#0EC07F"];
    self.alertTipLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    [self addSubview:self.alertTipLabel];
    //
    self.cancelAlertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelAlertBtn.frame = CGRectMake(0,0,16,16);
    self.cancelAlertBtn.layer.masksToBounds = YES;
    self.cancelAlertBtn.layer.cornerRadius = 8;
    self.cancelAlertBtn.center = CGPointMake(self.frame.size.width-16,self.textLabel.frame.size.height+self.alertTipLabel.frame.size.height/2);
    self.cancelAlertBtn.backgroundColor = [UIColor colorWithHexString:@"#41D395"];
    [self.cancelAlertBtn setImage:[UIImage imageNamed:@"Discover-cancel-alert"] forState:UIControlStateNormal];
    [self addSubview:self.cancelAlertBtn];
}
@end
