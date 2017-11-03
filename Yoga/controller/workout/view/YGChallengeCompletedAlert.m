//
//  YGChallengeCompleteAletView.m
//  Yoga
//
//  Created by lyj on 2017/9/29.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGStringUtil.h"
#import "UIColor+Extension.h"
#import "YGChallengeCompletedAlert.h"
@interface YGChallengeCompletedAlert ()
@property (nonatomic,strong) UIButton    *cancelBtn;
@property (nonatomic,strong) UIView      *backGroundv;
@property (nonatomic,strong) UILabel     *contentLabel;
@property (nonatomic,strong) UILabel     *tipLabel;
@property (nonatomic,strong) UIImageView *logoImgv;

@end
@implementation YGChallengeCompletedAlert

-(id)initWithFrame:(CGRect)frame challengeTittle:(NSString*)tittle{
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
        CGRect contentRect = CGRectMake(24*scale,CGRectGetMaxY(self.tipLabel.frame)+8*scale,self.backGroundv.frame.size.width-48*scale,100);
        self.contentLabel = [[UILabel alloc] initWithFrame:contentRect];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.text = tittle;
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        self.contentLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16*scale];
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
        self.startNewChallengeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.startNewChallengeBtn.frame = CGRectMake(self.shareToFacebookBtn.frame.origin.x,CGRectGetMaxY(self.shareToFacebookBtn.frame)+16*scale,self.backGroundv.frame.size.width-self.shareToFacebookBtn.frame.origin.x*2,self.shareToFacebookBtn.frame.size.height);
        self.startNewChallengeBtn.layer.masksToBounds = YES;
        self.startNewChallengeBtn.layer.cornerRadius = self.startNewChallengeBtn.frame.size.height/2;
        self.startNewChallengeBtn.layer.borderWidth = 1.0f;
        self.startNewChallengeBtn.layer.borderColor = [UIColor colorWithHexString:@"#0EC07F"].CGColor;
        [self.startNewChallengeBtn setTitle:@"START NEW CHALLENGE" forState:UIControlStateNormal];
        [self.startNewChallengeBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
        [self.startNewChallengeBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14*scale]];
        [self.backGroundv addSubview:self.startNewChallengeBtn];
        
        backGroundRect.size.height = CGRectGetMaxY(self.startNewChallengeBtn.frame)+shareToFacebookMargin;
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
    }
    return self;
}

-(void)hide{
    [UIView animateWithDuration:0.5 animations:^{
        self.cancelBtn.alpha = 0;
        self.shareToFacebookBtn.alpha = 0;
        self.startNewChallengeBtn.alpha = 0;
        self.tipLabel.alpha = 0;
        self.contentLabel.alpha = 0;
        self.logoImgv.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.logoImgv removeFromSuperview];
        [self.tipLabel removeFromSuperview];
        [self.shareToFacebookBtn removeFromSuperview];
        [self.startNewChallengeBtn removeFromSuperview];
        [self.cancelBtn removeFromSuperview];
        [self removeFromSuperview];
    }];
}







//-(id)initWithAlertMsg:(NSString*)msg{
//    self = [super initWithFrame:[self mainWindow].bounds];
//    if (self) {
//        [self setChallengeAlertWithMsg:msg];
//        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
//    }
//    return self;
//
//}
//
//-(void)setChallengeAlertWithMsg:(NSString*)msg{
//    [self addBackGroundv];
//    [self addChangeIconImgv];
//    [self addChangeTipLabel];
//    [self addMessageLabel];
//    [self addShareToFacebookBtn];
//    [self addStartNewChallengeBtn];
//    self.backGroundv.frame = CGRectMake(0,0,self.backGroundv.frame.size.width,CGRectGetMaxY(self.startNewChallengeBtn.frame)+24);
//    self.backGroundv.center = self.center;
//    [self addCancelBtn];
//    self.messageLabel.text = msg;
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
//-(void)addChangeIconImgv{
//    self.changeIconImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Challenge-c"]];
//    self.changeIconImgv.center = CGPointMake(self.backGroundv.frame.size.width/2,40+self.changeIconImgv.frame.size.height/2);
//    [self.backGroundv addSubview:self.changeIconImgv];
//}
//
//-(void)addChangeTipLabel{
//    self.changeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.changeIconImgv.frame)+24,self.backGroundv.frame.size.width,30)];
//    self.changeTipLabel.text = @"CONGRATULATIONS, YOU HAVE \nCOMPLETED:";
//    self.changeTipLabel.numberOfLines = 0;
//    self.changeTipLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
//    self.changeTipLabel.textAlignment = NSTextAlignmentCenter;
//    self.changeTipLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12];
//    [self.backGroundv addSubview:self.changeTipLabel];
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
//    CGFloat messageMarginY = CGRectGetMaxY(self.changeTipLabel.frame)+8;
//    self.messageLabel = [[UILabel alloc] init];
//    self.messageLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
//    self.messageLabel.textColor = [UIColor colorWithHexString:@"#000000"];
//    self.messageLabel.textAlignment = NSTextAlignmentCenter;
//    self.messageLabel.frame = CGRectMake(24,messageMarginY,self.backGroundv.frame.size.width-48,19);
//    [self.backGroundv addSubview:self.messageLabel];
//}
//
//-(void)addShareToFacebookBtn{
//    self.shareToFacebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.shareToFacebookBtn.frame = CGRectMake(24,CGRectGetMaxY(self.messageLabel.frame)+24,self.backGroundv.frame.size.width-48,48);
//    self.shareToFacebookBtn.layer.masksToBounds = YES;
//    self.shareToFacebookBtn.layer.cornerRadius = self.shareToFacebookBtn.frame.size.height/2;
//    self.shareToFacebookBtn.backgroundColor = [UIColor colorWithHexString:@"#4A90E2"];
//    [self.shareToFacebookBtn setTitle:@"SHARE ON FACEBOOK" forState:UIControlStateNormal];
//    [self.shareToFacebookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.shareToFacebookBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
//    self.shareToFacebookBtn.hidden = YES;
//    [self.backGroundv addSubview:self.shareToFacebookBtn];
//}
//
//-(void)addStartNewChallengeBtn{
//    self.startNewChallengeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.startNewChallengeBtn.frame = CGRectMake(24,CGRectGetMaxY(self.messageLabel.frame)+24,self.backGroundv.frame.size.width-48,48);
//    self.startNewChallengeBtn.layer.masksToBounds = YES;
//    self.startNewChallengeBtn.layer.cornerRadius = self.startNewChallengeBtn.frame.size.height/2;
//    self.startNewChallengeBtn.layer.borderWidth = 1.0f;
//    self.startNewChallengeBtn.layer.borderColor = [UIColor colorWithHexString:@"#0EC07F"].CGColor;
//    [self.startNewChallengeBtn setTitle:@"START NEW CHALLENGE" forState:UIControlStateNormal];
//    [self.startNewChallengeBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
//    [self.startNewChallengeBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
//    [self.backGroundv addSubview:self.startNewChallengeBtn];
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
