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
        CGFloat scale = 1;
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
        self.tipLabel.text = @"CONGRATULATIONS! \n YOU HAVE COMPLETED:";
        self.tipLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        self.tipLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12*scale];
        [self.backGroundv addSubview:self.tipLabel];
        //
        CGRect contentRect = CGRectMake(24*scale,CGRectGetMaxY(self.tipLabel.frame)+8*scale,self.backGroundv.frame.size.width-48*scale,100);
        self.contentLabel = [[UILabel alloc] initWithFrame:contentRect];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.text = [NSString stringWithFormat:@"%@\n\n Share with friends to earn bonus classes", tittle];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        self.contentLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16*scale];
        [self.contentLabel sizeToFit];
        contentRect.size.height = self.contentLabel.frame.size.height;
        self.contentLabel.frame = contentRect;
        [self.backGroundv addSubview:self.contentLabel];
        //
        CGFloat shareBtnMargin = 24*scale;
        CGFloat shareBtnWidth  = (self.backGroundv.frame.size.width-shareBtnMargin*2);
        CGFloat shareBtnHeight = shareBtnWidth*(88/526.0);
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareBtn.frame = CGRectMake(shareBtnMargin,CGRectGetMaxY(self.contentLabel.frame)+shareBtnMargin,shareBtnWidth,shareBtnHeight);
        self.shareBtn.layer.masksToBounds = YES;
        self.shareBtn.backgroundColor = [UIColor colorWithHexString:@"#41D395"];
        self.shareBtn.layer.cornerRadius = self.shareBtn.frame.size.height/2;
        [self.shareBtn setTitle:@"SHARE & EARN" forState:UIControlStateNormal];
        [self.shareBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.shareBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14*scale]];
        [self.backGroundv addSubview:self.shareBtn];
        //
        self.startNewChallengeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.startNewChallengeBtn.frame = CGRectMake(self.shareBtn.frame.origin.x,CGRectGetMaxY(self.shareBtn.frame)+16*scale,self.backGroundv.frame.size.width-self.shareBtn.frame.origin.x*2,self.shareBtn.frame.size.height);
        self.startNewChallengeBtn.layer.masksToBounds = YES;
        self.startNewChallengeBtn.layer.cornerRadius = self.startNewChallengeBtn.frame.size.height/2;
        self.startNewChallengeBtn.layer.borderWidth = 1.0f;
        self.startNewChallengeBtn.layer.borderColor = [UIColor colorWithHexString:@"#0EC07F"].CGColor;
        [self.startNewChallengeBtn setTitle:@"Start New Challenge" forState:UIControlStateNormal];
        [self.startNewChallengeBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
        [self.startNewChallengeBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14*scale]];
        [self.backGroundv addSubview:self.startNewChallengeBtn];
        
        backGroundRect.size.height = CGRectGetMaxY(self.startNewChallengeBtn.frame)+shareBtnMargin;
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
        self.shareBtn.alpha = 0;
        self.startNewChallengeBtn.alpha = 0;
        self.tipLabel.alpha = 0;
        self.contentLabel.alpha = 0;
        self.logoImgv.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.logoImgv removeFromSuperview];
        [self.tipLabel removeFromSuperview];
        [self.shareBtn removeFromSuperview];
        [self.startNewChallengeBtn removeFromSuperview];
        [self.cancelBtn removeFromSuperview];
        [self removeFromSuperview];
    }];
}
@end
