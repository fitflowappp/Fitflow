//
//  YGChangeChallengeAlertView.m
//  Yoga
//
//  Created by lyj on 2017/9/27.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGStringUtil.h"
#import "UIColor+Extension.h"
#import "YGChangeChallengeAlert.h"
@interface YGChangeChallengeAlert ()
@property (nonatomic,strong) UIButton    *cancelBtn;
@property (nonatomic,strong) UIView      *backGroundv;
@property (nonatomic,strong) UILabel     *contentLabel;
@property (nonatomic,strong) UILabel     *tipLabel;
@property (nonatomic,strong) UIImageView *logoImgv;

@end
@implementation YGChangeChallengeAlert

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
        self.logoImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Challenge-c"]];
        self.logoImgv.center = CGPointMake(self.backGroundv.frame.size.width/2,40*scale+self.logoImgv.frame.size.height/2);
        [self.backGroundv addSubview:self.logoImgv];
        //
        CGRect tipRect = CGRectMake(24*scale,CGRectGetMaxY(self.logoImgv.frame)+24*scale,self.backGroundv.frame.size.width-24*scale*2,30*scale);
        self.tipLabel = [[UILabel alloc] initWithFrame:tipRect];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.text = @"CHANGE CHALLENGE?";
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
        self.changeBtn.layer.borderWidth = 1.0f;
        self.changeBtn.layer.borderColor = [UIColor colorWithHexString:@"#0EC07F"].CGColor;
        self.changeBtn.layer.cornerRadius = self.changeBtn.frame.size.height/2;
        [self.changeBtn setTitle:@"CHANGE CHALLENGE" forState:UIControlStateNormal];
        [self.changeBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
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
//    NSMutableAttributedString *aMsg = [self attributeString:msg];
//    self.changeIconImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Challenge-c"]];
//    CGFloat height = 40+self.changeIconImgv.frame.size.height+24+15+8+[YGStringUtil boundString:aMsg inSize:CGSizeMake(self.frame.size.width-96, MAXFLOAT)].height+24+48+24;
//    CGFloat marginX = 24;
//    self.backGroundv = [[UIView alloc] initWithFrame:CGRectMake(marginX,0,self.frame.size.width-marginX*2,height)];
//    self.backGroundv.backgroundColor = [UIColor whiteColor];
//    self.backGroundv.layer.masksToBounds = YES;
//    self.backGroundv.layer.cornerRadius = 10;
//    self.backGroundv.center = self.center;
//    [self addSubview:self.backGroundv];
//    self.changeIconImgv.center = CGPointMake(self.backGroundv.frame.size.width/2,40+self.changeIconImgv.frame.size.height/2);
//    [self.backGroundv addSubview:self.changeIconImgv];
//    [self addChangeTipLabel];
//    [self addChangeBtn];
//    [self addMessageLabel];
//    [self addCancelBtn];
//    self.messageLabel.attributedText = aMsg;
//    [self.messageLabel sizeToFit];
//}
//
//-(void)addBackGroundv{
//    self.backGroundv = [[UIView alloc] initWithFrame:CGRectMake(24,0,self.frame.size.width-24*2,self.frame.size.height)];
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
//    self.changeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.changeIconImgv.frame)+24,self.backGroundv.frame.size.width,15)];
//    self.changeTipLabel.text = @"CHANGE CHALLENGE?";
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
//    self.messageLabel.numberOfLines = 0;
//    self.messageLabel.frame = CGRectMake(24,messageMarginY,self.backGroundv.frame.size.width-48,self.changeBtn.frame.origin.y-24-messageMarginY);
//    [self.backGroundv addSubview:self.messageLabel];
//}
//
//-(void)addChangeBtn{
//    self.changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.changeBtn.frame = CGRectMake(24,self.backGroundv.frame.size.height-48-24,self.backGroundv.frame.size.width-48,48);
//    self.changeBtn.layer.masksToBounds = YES;
//    self.changeBtn.layer.cornerRadius = self.changeBtn.frame.size.height/2;
//    self.changeBtn.layer.borderWidth = 1.0f;
//    self.changeBtn.layer.borderColor = [UIColor colorWithHexString:@"#0EC07F"].CGColor;
//    [self.changeBtn setTitle:@"CHANGE CHALLENGE" forState:UIControlStateNormal];
//    [self.changeBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
//    [self.changeBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
//    [self.backGroundv addSubview:self.changeBtn];
//}
//
//-(NSMutableAttributedString*)attributeString:(NSString*)msg{
//    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:msg];
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.paragraphSpacing = 19;
//    style.alignment = NSTextAlignmentCenter;
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:[UIFont fontWithName:@"Lato-Regular" size:16] forKey:NSFontAttributeName];
//    [params setObject:style forKey:NSParagraphStyleAttributeName];
//    [aString addAttributes:params range:NSMakeRange(0,aString.length)];
//    return aString;
//}
//
//
//-(UIWindow*)mainWindow{
//    return [UIApplication sharedApplication].delegate.window;
//}
//
//-(void)didSelectCancelBtn{
//    [self removeFromSuperview];
//}
//
//
//-(void)show{
////    MBProgressHUD* hud= [MBProgressHUD showHUDAddedTo:[self mainWindow] animated:NO];
////    hud.backgroundColor=[UIColor clearColor];
////    hud.removeFromSuperViewOnHide = YES;
////    hud.mode = MBProgressHUDModeCustomView;
////    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
////    hud.bezelView.color=[UIColor redColor];
////    hud.backgroundView.color = [UIColor clearColor];
////    hud.customView = self;
////    [hud showAnimated:YES];
//}
@end
