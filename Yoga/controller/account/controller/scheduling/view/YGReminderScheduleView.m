//
//  YGReminderScheduleView.m
//  Yoga
//
//  Created by lyj on 2017/10/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGReminderScheduleView.h"
@interface YGReminderScheduleView ()
@property (nonatomic,strong) UIButton *hideBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) NSArray  *scheduleList;
@property (nonatomic,strong) UILabel  *titleLabel;
@end
@implementation YGReminderScheduleView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setReminderScheduleView];
    }
    return self;
}

-(void)setReminderScheduleView{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.alpha = 0;
    /**/
    [self addDatePicker];
    [self addTitleLabel];
    [self addCancelBtn];
    [self addSureBtn];
    [self addHideBtn];
    [self show];
}

-(void)addTitleLabel{
    CGFloat scale = SCALE;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.datePicker.frame.origin.y-48*scale,self.frame.size.width,48*scale)];
    self.titleLabel.text = @"Set your reminder time";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16*scale];
    [self addSubview:self.titleLabel];
}

-(void)addCancelBtn{
    CGFloat scale = SCALE;
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(0,self.titleLabel.frame.origin.y,45*scale+32*scale,self.titleLabel.frame.size.height);
    [self.cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor colorWithHexString:@"#41D395"] forState:UIControlStateNormal];
    [self.cancelBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Semibold" size:14*scale]];
    [self.cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
}

-(void)addSureBtn{
    CGFloat scale = SCALE;
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureBtn.frame = CGRectMake(self.frame.size.width-45*scale-32*scale,self.titleLabel.frame.origin.y,45*scale+32*scale,self.titleLabel.frame.size.height);
    [self.sureBtn setTitle:@"Accept" forState:UIControlStateNormal];
    [self.sureBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Semibold" size:14*scale]];
    [self.sureBtn setTitleColor:[UIColor colorWithHexString:@"#41D395"] forState:UIControlStateNormal];
    [self addSubview:self.sureBtn];
}

-(void)addDatePicker{
    CGFloat scale = SCALE;
    CGFloat H = 32*2*scale+56*2*scale+16*scale;
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,self.frame.size.height+H+48*scale,self.frame.size.width, H)];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    self.datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [self addSubview:self.datePicker];
}

-(void)addHideBtn{
    self.hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hideBtn.backgroundColor = [UIColor clearColor];
    self.hideBtn.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height-self.datePicker.frame.size.height-self.titleLabel.frame.size.height);
    [self.hideBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.hideBtn];
}

-(void)hide{
    CGRect rect1 = self.datePicker.frame;
    CGRect rect2 = self.titleLabel.frame;
    CGRect rect3 = self.cancelBtn.frame;
    CGRect rect4 = self.sureBtn.frame;
    rect1.origin.y = self.frame.size.height+rect1.size.height+rect2.size.height;
    rect2.origin.y = self.frame.size.height +rect2.size.height;
    rect3.origin.y = rect2.origin.y;
    rect4.origin.y = rect2.origin.y;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.datePicker.frame = rect1;
        self.titleLabel.frame = rect2;
        self.cancelBtn.frame = rect3;
        self.sureBtn.frame = rect4;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.sureBtn removeFromSuperview];
        [self.cancelBtn removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.datePicker removeFromSuperview];
        [self.hideBtn removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(void)show{
    CGRect rect1 = self.datePicker.frame;
    CGRect rect2 = self.titleLabel.frame;
    CGRect rect3 = self.cancelBtn.frame;
    CGRect rect4 = self.sureBtn.frame;
    rect1.origin.y = self.frame.size.height-rect1.size.height;
    rect2.origin.y = self.frame.size.height - rect1.size.height-rect2.size.height;
    rect3.origin.y = rect2.origin.y;
    rect4.origin.y = rect2.origin.y;
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.datePicker.frame = rect1;
        self.titleLabel.frame = rect2;
        self.cancelBtn.frame = rect3;
        self.sureBtn.frame = rect4;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
@end
