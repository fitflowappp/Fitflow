//
//  YGAccountLoginFooter.m
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGAccountLoginFooter.h"

@interface YGAccountLoginFooter ()
@property (nonatomic,strong) UIImageView *faceBookIconImgv;
@end

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
    [self addFaceBookIconImgv];
}

-(void)addLoginBtn{
    CGFloat scale = SCALE;
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(16*scale, 0,self.frame.size.width-32*scale,self.frame.size.height);
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = self.loginBtn.frame.size.height/2;
    [self.loginBtn setBackgroundColor:[UIColor colorWithHexString:@"#4A90E2"]];
    [self.loginBtn setTitle:@"LOGIN WITH FACEBOOK" forState:UIControlStateNormal];
    [self.loginBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16*scale]];
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self addSubview:self.loginBtn];
}

-(void)addFaceBookIconImgv{
    CGFloat scale = SCALE;
    self.faceBookIconImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook-white"]];
    self.faceBookIconImgv.center = CGPointMake(16*scale+self.faceBookIconImgv.frame.size.width/2,self.loginBtn.frame.size.height/2);
    [self.loginBtn addSubview:self.faceBookIconImgv];
}
@end
