//
//  YGHomeUpdataAlert.m
//  Yoga
//
//  Created by 何侨 on 2018/1/25.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGHomeUpdataAlert.h"
#import "UIColor+Extension.h"

@interface YGHomeUpdataAlert()

@property (nonatomic,weak) UIButton    *cancelBtn;
@property (nonatomic,weak) UIView      *backGroundv;
@property (nonatomic,weak) UILabel     *contentLabel;
@property (nonatomic,weak) UIImageView *logoImgv;
@property (nonatomic,weak) UIButton *laterOrLeaveBtn;
@property (nonatomic,assign) NSInteger type;
@end

@implementation YGHomeUpdataAlert

- (instancetype)initWithFrame:(CGRect)frame contentTittle:(NSString*)tittle UpdataType:(NSInteger)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        CGFloat scale = SCALE;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        //
        CGRect backGroundRect = CGRectMake(32*scale,0,self.frame.size.width-64*scale,700);
        UIView *backGroundv = [[UIView alloc] initWithFrame:backGroundRect];
        self.backGroundv = backGroundv;
        self.backGroundv.layer.masksToBounds = YES;
        self.backGroundv.layer.cornerRadius = 10*scale;
        self.backGroundv.backgroundColor = [UIColor whiteColor];
        //
        UIImageView *logoImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_update"]];
        self.logoImgv = logoImgv;
        self.logoImgv.center = CGPointMake(self.backGroundv.frame.size.width/2,40*scale+self.logoImgv.frame.size.height/2);
        [self.backGroundv addSubview:self.logoImgv];
        //
        //NSString *content = @"You can schedule regular reminders below to help you build healthy workout habits.";
        CGRect contentRect = CGRectMake(24*scale,CGRectGetMaxY(self.logoImgv.frame)+8*scale,self.backGroundv.frame.size.width-48*scale,100);
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:contentRect];
        self.contentLabel = contentLabel;
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
        
        UIButton *updataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.updataBtn = updataBtn;
        self.updataBtn.frame = CGRectMake(changeMargin,CGRectGetMaxY(self.contentLabel.frame)+changeMargin,changeWidth,changeHeight);
        self.updataBtn.layer.masksToBounds = YES;
        self.updataBtn.layer.borderWidth = 1.0f;
        self.updataBtn.layer.borderColor = [UIColor colorWithHexString:@"#0EC07F"].CGColor;
        self.updataBtn.layer.cornerRadius = self.updataBtn.frame.size.height/2;
        [self.updataBtn setTitle:@"UPDATE NOW" forState:UIControlStateNormal];
        [self.updataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.updataBtn.backgroundColor = [UIColor colorWithHexString:@"#0EC07F"];
        [self.updataBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14*scale]];
        [self.backGroundv addSubview:self.updataBtn];
        
        CGFloat leadveMargin = 16*scale;
        UIButton *leaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.laterOrLeaveBtn = leaveBtn;
        self.laterOrLeaveBtn.frame = CGRectMake(changeMargin,CGRectGetMaxY(self.updataBtn.frame)+leadveMargin,changeWidth,changeHeight);
        self.laterOrLeaveBtn.layer.masksToBounds = YES;
        self.laterOrLeaveBtn.layer.borderWidth = 1.0f;
        self.laterOrLeaveBtn.layer.borderColor = [UIColor colorWithHexString:@"#0EC07F"].CGColor;
        self.laterOrLeaveBtn.layer.cornerRadius = self.updataBtn.frame.size.height/2;
        [self.laterOrLeaveBtn setTitle:type ? @"Leave Fitflow" : @"Maybe Later" forState:UIControlStateNormal];
        [self.laterOrLeaveBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
        [self.laterOrLeaveBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14*scale]];
        [self.backGroundv addSubview:self.laterOrLeaveBtn];
        [self.laterOrLeaveBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        //
        backGroundRect.size.height = CGRectGetMaxY(self.laterOrLeaveBtn.frame)+changeMargin;
        self.backGroundv.frame = backGroundRect;
        self.backGroundv.center = self.center;
        [self addSubview:self.backGroundv];
        //
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn = cancelBtn;
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
        self.cancelBtn.alpha = type ? 0 : 1;
        self.backGroundv.alpha = 0;
        [self show];
    }
    return self;
    
}

-(void)hide{
   
    if (self.type) {
        return;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        self.cancelBtn.alpha = 0;
        self.logoImgv.alpha = 0;
        self.backGroundv.alpha = 0;
        self.contentLabel.alpha = 0;
        self.updataBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [self.logoImgv removeFromSuperview];
        [self.updataBtn removeFromSuperview];
        [self.backGroundv removeFromSuperview];
        [self.cancelBtn removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)cancelAction
{
    if (self.type) {
        exit(0);
        return;
    }
    [self hide];
}

- (void)show{
    [UIView animateWithDuration:0.2 animations:^{
        self.cancelBtn.alpha = self.type ? 0 : 1;
        self.backGroundv.alpha = 1;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}




@end
