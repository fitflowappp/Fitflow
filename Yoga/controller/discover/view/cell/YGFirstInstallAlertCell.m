//
//  YGFirstInstallAlertCell.m
//  Yoga
//
//  Created by lyj on 2018/1/5.
//  Copyright © 2018年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGFirstInstallAlertCell.h"
@interface YGFirstInstallAlertCell ()
@property (nonatomic,strong) UILabel *textLabel;
@end
@implementation YGFirstInstallAlertCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpFirstInstallAlertCell];
    }
    return self;
}

-(void)setUpFirstInstallAlertCell{
    self.backgroundColor = [UIColor colorWithHexString:@"#E5F9F1"];
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(32,0,self.frame.size.width-64,self.frame.size.height)];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.numberOfLines = 0;
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textColor = [UIColor colorWithHexString:@"#0EC07F"];
    self.textLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    [self addSubview:self.textLabel];
    //
    self.cancelAlertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelAlertBtn.frame = CGRectMake(0,0,16,16);
    self.cancelAlertBtn.layer.masksToBounds = YES;
    self.cancelAlertBtn.layer.cornerRadius = 8;
    self.cancelAlertBtn.center = CGPointMake(self.frame.size.width-16,self.frame.size.height/2);
    self.cancelAlertBtn.backgroundColor = [UIColor colorWithHexString:@"#41D395"];
    [self.cancelAlertBtn setImage:[UIImage imageNamed:@"Discover-cancel-alert"] forState:UIControlStateNormal];
    [self addSubview:self.cancelAlertBtn];
}

-(void)setText:(NSString *)text{
    if ([text isEqualToString:_text]==NO) {
        _text = text;
        self.textLabel.text = text;
    }
    
}
@end
