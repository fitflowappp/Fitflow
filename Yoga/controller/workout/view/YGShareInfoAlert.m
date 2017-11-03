//
//  YGShareInfoAlert.m
//  Yoga
//
//  Created by lyj on 2017/10/17.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGShareInfoAlert.h"
@interface YGShareInfoAlert ()
@property (nonatomic,strong) UILabel      *tipLabel;
@property (nonatomic,strong) UIView       *backGroundv;
@property (nonatomic,strong) UIImageView  *logoImgv;
@property (nonatomic,strong) UILabel      *contentLabel;

@end
@implementation YGShareInfoAlert

-(id)initWithFrame:(CGRect)frame shareInfo:(NSDictionary*)shareInfo{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat scale = SCALE;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        //
        CGRect backGroundRect = CGRectMake(32*scale,0,self.frame.size.width-64*scale,700);
        self.backGroundv = [[UIView alloc] initWithFrame:backGroundRect];
        self.backGroundv.layer.masksToBounds = YES;
        self.backGroundv.layer.cornerRadius = 10*scale;
        self.backGroundv.backgroundColor = [UIColor whiteColor];
        //
        self.logoImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Challenge-c"]];
        self.logoImgv.center = CGPointMake(self.backGroundv.frame.size.width/2,40*scale+self.logoImgv.frame.size.height/2);
        [self.backGroundv addSubview:self.logoImgv];
        //
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.logoImgv.frame)+24*scale,self.backGroundv.frame.size.width,30*scale)];
        self.tipLabel.numberOfLines = 0;
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.text = @"CONGRATULATIONS, YOU HAVE \nCOMPLETED:";
        self.tipLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        self.tipLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12*scale];
        [self.backGroundv addSubview:self.tipLabel];
        //
        NSString *content = [shareInfo objectForKey:@"content"];
        CGRect contentRect = CGRectMake(24*scale,CGRectGetMaxY(self.tipLabel.frame)+8*scale,self.backGroundv.frame.size.width-48*scale,100);
        self.contentLabel = [[UILabel alloc] initWithFrame:contentRect];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.text = content;
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        self.contentLabel.font = [UIFont fontWithName:@"Lato-Bold" size:20*scale];
        [self.contentLabel sizeToFit];
        contentRect.size.height = self.contentLabel.frame.size.height;
        self.contentLabel.frame = contentRect;
        [self.backGroundv addSubview:self.contentLabel];
        //
        CGFloat shareToFacebookMargin = 24*scale;
        CGFloat shareToFacebookWidth  = (self.backGroundv.frame.size.width-shareToFacebookMargin*2);
        CGFloat shareToFacebookHeight = shareToFacebookWidth*(88/526.0);
        self.shareToFacebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareToFacebookBtn.frame = CGRectMake(shareToFacebookMargin,CGRectGetMaxY(self.contentLabel.frame)+shareToFacebookMargin,shareToFacebookWidth,shareToFacebookHeight);
        self.shareToFacebookBtn.layer.masksToBounds = YES;
        self.shareToFacebookBtn.backgroundColor = [UIColor colorWithHexString:@"#4A90E2"];
        self.shareToFacebookBtn.layer.cornerRadius = self.shareToFacebookBtn.frame.size.height/2;
        [self.shareToFacebookBtn setTitle:@"SHARE ON FACEBOOK" forState:UIControlStateNormal];
        [self.shareToFacebookBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.shareToFacebookBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14*scale]];
        [self.backGroundv addSubview:self.shareToFacebookBtn];
        //
        backGroundRect.size.height = CGRectGetMaxY(self.shareToFacebookBtn.frame)+shareToFacebookMargin;
        self.backGroundv.frame = backGroundRect;
        self.backGroundv.center = self.center;
        [self addSubview:self.backGroundv];
        //
        self.cancelShareToFacebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelShareToFacebookBtn setImage:[UIImage imageNamed:@"Cancel-green"] forState:UIControlStateNormal];
        self.cancelShareToFacebookBtn.layer.masksToBounds = YES;
        self.cancelShareToFacebookBtn.backgroundColor = [UIColor whiteColor];
        self.cancelShareToFacebookBtn.bounds = CGRectMake(0,0,32*scale,32*scale);
        self.cancelShareToFacebookBtn.layer.cornerRadius = self.cancelShareToFacebookBtn.frame.size.width/2;
        self.cancelShareToFacebookBtn.center = CGPointMake(CGRectGetMaxX(self.backGroundv.frame),self.backGroundv.frame.origin.y);
        [self addSubview:self.cancelShareToFacebookBtn];
    }
    return self;
}

-(void)hide{
    [UIView animateWithDuration:0.5 animations:^{
        self.cancelShareToFacebookBtn.alpha = 0;
        self.shareToFacebookBtn.alpha = 0;
        self.tipLabel.alpha = 0;
        self.contentLabel.alpha = 0;
        self.logoImgv.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.logoImgv removeFromSuperview];
        [self.tipLabel removeFromSuperview];
        [self.shareToFacebookBtn removeFromSuperview];
        [self.cancelShareToFacebookBtn removeFromSuperview];
        [self removeFromSuperview];
    }];
}
@end
