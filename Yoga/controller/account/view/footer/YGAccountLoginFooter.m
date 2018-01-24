//
//  YGAccountLoginFooter.m
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGAccountLoginFooter.h"
@implementation YGAccountLoginFooter
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAccountLoginFooter];
    }
    return self;
}

-(void)setAccountLoginFooter{
    self.backgroundColor = [UIColor clearColor];
    [self addLoginBtn];
}

-(void)addLoginBtn{
    CGFloat scale = 1;
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(16*scale, 0,self.frame.size.width-32*scale,self.frame.size.height);
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.borderColor  = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    self.loginBtn.layer.cornerRadius = self.loginBtn.frame.size.height/2;
    [self.loginBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16*scale]];
    [self addSubview:self.loginBtn];
}

-(void)setRegisterStatus:(BOOL)unRegister{
    if (unRegister) {
        self.loginBtn.layer.borderWidth = 0;
        [self.loginBtn setTitle:@"LOGIN" forState:UIControlStateNormal];
        [self.loginBtn setBackgroundColor:[UIColor colorWithHexString:@"#41D395"]];
        [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }else{
        self.loginBtn.layer.borderWidth = 0.5;
        [self.loginBtn setTitle:@"LOGOUT" forState:UIControlStateNormal];
        [self.loginBtn setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
        [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"#A4A3A3"] forState:UIControlStateNormal];
    }
    
}
@end
