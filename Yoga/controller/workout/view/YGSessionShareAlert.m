//
//  YGSessionShareAlert.m
//  Yoga
//
//  Created by 何侨 on 2018/1/29.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGSessionShareAlert.h"
#import "YGStringUtil.h"
#import "UIColor+Extension.h"
@interface YGSessionShareAlert ()
@property (nonatomic,strong) UIButton    *cancelBtn;
@property (nonatomic,strong) UIView      *backGroundv;
@property (nonatomic,strong) UILabel     *contentLabel;
@property (nonatomic,strong) UILabel     *tipLabel;
@property (nonatomic,strong) UIImageView *logoImgv;

@end
@implementation YGSessionShareAlert

-(id)initWithFrame:(CGRect)frame contentTittle:(NSString*)tittle{
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
        self.logoImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lock-c"]];
        self.logoImgv.center = CGPointMake(self.backGroundv.frame.size.width/2,40*scale+self.logoImgv.frame.size.height/2);
        [self.backGroundv addSubview:self.logoImgv];
        //
        CGRect tipRect = CGRectMake(24*scale,CGRectGetMaxY(self.logoImgv.frame)+24*scale,self.backGroundv.frame.size.width-24*scale*2,30*scale);
        self.tipLabel = [[UILabel alloc] initWithFrame:tipRect];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.text = @"LOCKED BONUS CLASS";
        self.tipLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        self.tipLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12*scale];
        [self.tipLabel sizeToFit];
        tipRect.size.height = self.tipLabel.frame.size.height;
        self.tipLabel.frame = tipRect;
        [self.backGroundv addSubview:self.tipLabel];
        //
        //NSString *content = @"You can schedule regular reminders below to help you build healthy workout habits.";
        CGRect contentRect = CGRectMake(24*scale,CGRectGetMaxY(self.tipLabel.frame)+8*scale,self.backGroundv.frame.size.width-48*scale,100);
        self.contentLabel = [[UILabel alloc] initWithFrame:contentRect];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.text = tittle;
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        self.contentLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16*scale];
        [self.contentLabel sizeToFit];
        contentRect.size.height = self.contentLabel.frame.size.height;
        self.contentLabel.frame = contentRect;
        [self.backGroundv addSubview:self.contentLabel];
        //
        CGFloat changeMargin = 24*scale;
        CGFloat changeWidth  = (self.backGroundv.frame.size.width-changeMargin*2);
        CGFloat changeHeight = changeWidth*(88/526.0);
        self.changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.changeBtn.frame = CGRectMake(changeMargin,CGRectGetMaxY(self.contentLabel.frame)+changeMargin,changeWidth,changeHeight);
        self.changeBtn.layer.masksToBounds = YES;
        self.changeBtn.backgroundColor = [UIColor colorWithHexString:@"41D395"];
        self.changeBtn.layer.cornerRadius = self.changeBtn.frame.size.height/2;
        [self.changeBtn setTitle:@"SHARE TO UNLOCK" forState:UIControlStateNormal];
        [self.changeBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.changeBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14*scale]];
        [self.backGroundv addSubview:self.changeBtn];
        //
        backGroundRect.size.height = CGRectGetMaxY(self.changeBtn.frame)+changeMargin;
        self.backGroundv.frame = backGroundRect;
        self.backGroundv.center = self.center;
        [self addSubview:self.backGroundv];
        //
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelBtn setImage:[UIImage imageNamed:@"Cancel-green"] forState:UIControlStateNormal];
        self.cancelBtn.layer.masksToBounds = YES;
        self.cancelBtn.backgroundColor = [UIColor whiteColor];
        self.cancelBtn.bounds = CGRectMake(0,0,32*scale,32*scale);
        self.cancelBtn.layer.cornerRadius = self.cancelBtn.frame.size.width/2;
        self.cancelBtn.center = CGPointMake(CGRectGetMaxX(self.backGroundv.frame),self.backGroundv.frame.origin.y);
        [self.cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelBtn];
        //
        self.alpha = 0;
        self.cancelBtn.alpha = 0;
        self.backGroundv.alpha = 0;
        [self show];
    }
    return self;
    
}

-(void)hide{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        self.cancelBtn.alpha = 0;
        self.tipLabel.alpha = 0;
        self.logoImgv.alpha = 0;
        self.backGroundv.alpha = 0;
        self.contentLabel.alpha = 0;
        self.changeBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [self.logoImgv removeFromSuperview];
        [self.tipLabel removeFromSuperview];
        [self.changeBtn removeFromSuperview];
        [self.backGroundv removeFromSuperview];
        [self.cancelBtn removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(void)show{
    [UIView animateWithDuration:0.2 animations:^{
        self.cancelBtn.alpha = 1;
        self.backGroundv.alpha = 1;
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}




@end
