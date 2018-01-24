//
//  YGHomeAddSinglesFooter.m
//  Yoga
//
//  Created by lyj on 2018/1/4.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGHomeAddSinglesFooter.h"
#import "UIColor+Extension.h"
@implementation YGHomeAddSinglesFooter
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setHomeAddSinglesFooter];
    }
    return self;
}
-(void)setHomeAddSinglesFooter{
    CGFloat margin = 16;
    self.backgroundColor = [UIColor whiteColor];
    self.addSinglesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addSinglesBtn.frame = CGRectMake(margin,0,self.frame.size.width-margin*2,self.frame.size.height);
    self.addSinglesBtn.layer.masksToBounds = YES;
    self.addSinglesBtn.layer.cornerRadius = self.addSinglesBtn.frame.size.height/2;
    self.addSinglesBtn.layer.borderWidth = 0.5;
    self.addSinglesBtn.layer.borderColor = [UIColor colorWithHexString:@"#41D395"].CGColor;
    [self.addSinglesBtn setTitle:@"ADD MORE SINGLES" forState:UIControlStateNormal];
    [self.addSinglesBtn setTitleColor:[UIColor colorWithHexString:@"#41D395"] forState:UIControlStateNormal];
    [self.addSinglesBtn.titleLabel setFont:[UIFont fontWithName:@"lato-Bold" size:14]];
    self.addSinglesBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:self.addSinglesBtn];
}
@end
