//
//  YGChallengeUnCompletedAlert.m
//  Yoga
//
//  Created by lyj on 2017/9/29.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGStringUtil.h"
#import "UIColor+Extension.h"
#import "YGChallengeUnCompletedAlert.h"
@interface YGChallengeUnCompletedAlert ()
@property (nonatomic,strong) UILabel      *tipLabel;
@property (nonatomic,strong) UIView       *backGroundv;
@property (nonatomic,strong) UILabel      *contentLabel;
@property (nonatomic,strong) UIImageView  *logoImgv;
@property (nonatomic,strong) UIButton     *cancelBtn;

@end
@implementation YGChallengeUnCompletedAlert

-(id)initWithFrame:(CGRect)frame{
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
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.logoImgv.frame)+24*scale,self.backGroundv.frame.size.width,30*scale)];
        self.tipLabel.numberOfLines = 0;
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.text = @"THIS IS CURRENTLY LOCKED.";
        self.tipLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        self.tipLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12*scale];
        [self.backGroundv addSubview:self.tipLabel];
        //
        NSString *content = @"Complete your first challenge to unlock additional materials.";
        CGRect contentRect = CGRectMake(24*scale,CGRectGetMaxY(self.tipLabel.frame)+8*scale,self.backGroundv.frame.size.width-48*scale,100);
        self.contentLabel = [[UILabel alloc] initWithFrame:contentRect];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.text = content;
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        self.contentLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16*scale];
        [self.contentLabel sizeToFit];
        contentRect.size.height = self.contentLabel.frame.size.height;
        self.contentLabel.frame = contentRect;
        [self.backGroundv addSubview:self.contentLabel];
        //
        CGFloat backMargin = 24*scale;
        CGFloat backWidth  = (self.backGroundv.frame.size.width-backMargin*2);
        CGFloat backHeight = backWidth*(88/526.0);
        self.backToCurrentWorkoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backToCurrentWorkoutBtn.frame = CGRectMake(backMargin,CGRectGetMaxY(self.contentLabel.frame)+backMargin,backWidth,backHeight);
        self.backToCurrentWorkoutBtn.layer.masksToBounds = YES;
        self.backToCurrentWorkoutBtn.layer.borderWidth = 1.0f;
        self.backToCurrentWorkoutBtn.layer.borderColor = [UIColor colorWithHexString:@"#0EC07F"].CGColor;
        self.backToCurrentWorkoutBtn.layer.cornerRadius = self.backToCurrentWorkoutBtn.frame.size.height/2;
        [self.backToCurrentWorkoutBtn setTitle:@"GO TO MY WORKOUT" forState:UIControlStateNormal];
        [self.backToCurrentWorkoutBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
        [self.backToCurrentWorkoutBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14*scale]];
        [self.backGroundv addSubview:self.backToCurrentWorkoutBtn];
        //
        backGroundRect.size.height = CGRectGetMaxY(self.backToCurrentWorkoutBtn.frame)+backMargin;
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
        self.backToCurrentWorkoutBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [self.logoImgv removeFromSuperview];
        [self.tipLabel removeFromSuperview];
        [self.backToCurrentWorkoutBtn removeFromSuperview];
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






//-(id)initWithAlertMsg:(NSString*)msg{
//    self = [super initWithFrame:[self mainWindow].bounds];
//    if (self) {
//        [self setAlertWithMsg:msg];
//        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
//    }
//    return self;
//
//}
//
//-(void)setAlertWithMsg:(NSString*)msg{
//    [self addBackGroundv];
//    [self addLockedIconImgv];
//    [self addLockedTipLabel];
//    [self addMessageLabel];
//    self.messageLabel.text = msg;
//    [self.messageLabel sizeToFit];
//    self.messageLabel.frame =  self.messageLabel.frame = CGRectMake(24,CGRectGetMaxY(self.lockedTipLabel.frame)+8,self.backGroundv.frame.size.width-48,self.messageLabel.frame.size.height);
//    [self addBackToCurrentWorkoutBtn];
//    self.backGroundv.frame = CGRectMake(0,0,self.backGroundv.frame.size.width,CGRectGetMaxY(self.backToCurrentWorkoutBtn.frame)+24);
//    self.backGroundv.center = self.center;
//    [self addCancelBtn];
//}
//
//-(void)addBackGroundv{
//    self.backGroundv = [[UIView alloc] initWithFrame:CGRectMake(32,0,self.frame.size.width-32*2,self.frame.size.height)];
//    self.backGroundv.backgroundColor = [UIColor whiteColor];
//    self.backGroundv.layer.masksToBounds = YES;
//    self.backGroundv.layer.cornerRadius = 10;
//    [self addSubview:self.backGroundv];
//}
//
//-(void)addLockedIconImgv{
//    self.lockedIconImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lock-c"]];
//    self.lockedIconImgv.center = CGPointMake(self.backGroundv.frame.size.width/2,40+self.lockedIconImgv.frame.size.height/2);
//    [self.backGroundv addSubview:self.lockedIconImgv];
//}
//
//-(void)addLockedTipLabel{
//    self.lockedTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.lockedIconImgv.frame)+24,self.backGroundv.frame.size.width,30)];
//    self.lockedTipLabel.text = @"THIS IS CURRENTLY LOCKED.";
//    self.lockedTipLabel.numberOfLines = 0;
//    self.lockedTipLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
//    self.lockedTipLabel.textAlignment = NSTextAlignmentCenter;
//    self.lockedTipLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12];
//    [self.backGroundv addSubview:self.lockedTipLabel];
//}
//
//-(void)addCancelBtn{
//    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.cancelBtn setImage:[UIImage imageNamed:@"Cancel-green"] forState:UIControlStateNormal];
//    self.cancelBtn.bounds = CGRectMake(0,0,32,32);
//    self.cancelBtn.backgroundColor = [UIColor whiteColor];
//    self.cancelBtn.layer.masksToBounds = YES;
//    self.cancelBtn.layer.cornerRadius = self.cancelBtn.frame.size.width/2;
//    [self.cancelBtn addTarget:self action:@selector(didSelectCancelBtn) forControlEvents:UIControlEventTouchUpInside];
//    self.cancelBtn.center = CGPointMake(CGRectGetMaxX(self.backGroundv.frame),self.backGroundv.frame.origin.y);
//    [self addSubview:self.cancelBtn];
//}
//
//-(void)addMessageLabel{
//    CGFloat messageMarginY = CGRectGetMaxY(self.lockedTipLabel.frame)+8;
//    self.messageLabel = [[UILabel alloc] init];
//    self.messageLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
//    self.messageLabel.textColor = [UIColor colorWithHexString:@"#000000"];
//    self.messageLabel.textAlignment = NSTextAlignmentCenter;
//    self.messageLabel.numberOfLines = 0;
//    self.messageLabel.frame = CGRectMake(24,messageMarginY,self.backGroundv.frame.size.width-48,50);
//    [self.backGroundv addSubview:self.messageLabel];
//}
//
//-(void)addBackToCurrentWorkoutBtn{
//    self.backToCurrentWorkoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.backToCurrentWorkoutBtn.frame = CGRectMake(24,CGRectGetMaxY(self.messageLabel.frame)+16,self.backGroundv.frame.size.width-48,48);
//    self.backToCurrentWorkoutBtn.layer.masksToBounds = YES;
//    self.backToCurrentWorkoutBtn.layer.cornerRadius = self.backToCurrentWorkoutBtn.frame.size.height/2;
//    self.backToCurrentWorkoutBtn.layer.borderWidth = 1.0f;
//    self.backToCurrentWorkoutBtn.layer.borderColor = [UIColor colorWithHexString:@"#0EC07F"].CGColor;
//    [self.backToCurrentWorkoutBtn setTitle:@"GO TO MY WORKOUT" forState:UIControlStateNormal];
//    [self.backToCurrentWorkoutBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
//    [self.backToCurrentWorkoutBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
//    [self.backGroundv addSubview:self.backToCurrentWorkoutBtn];
//}
//
//-(UIWindow*)mainWindow{
//    return [UIApplication sharedApplication].delegate.window;
//}
//
//-(void)didSelectCancelBtn{
//    [self removeFromSuperview];
//}
@end
