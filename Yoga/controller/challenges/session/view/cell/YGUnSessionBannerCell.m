//
//  YGUnSessionBannerCell.m
//  Yoga
//
//  Created by 何侨 on 2018/1/29.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGUnSessionBannerCell.h"
#import "UIColor+Extension.h"
#import "UIImageView+AFNetworking.h"
@interface YGUnSessionBannerCell()
@property (nonatomic,strong) UIView  *darkv;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UIImageView *coverImgv;
//@property (nonatomic,strong) UIImageView *lockedImgv;
@property (nonatomic,strong) UIButton *favorateBtn;
@end

@implementation YGUnSessionBannerCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSessionBannerCell];
    }
    return self;
}

-(void)setSessionBannerCell{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    [self addCoverImgv];
    [self addLock];
    [self addTitleLabel];
    [self addSubTitleLabel];
    [self addLockImage];
}

-(void)addCoverImgv{
    self.coverImgv = [[UIImageView alloc] initWithFrame:self.bounds];
    self.coverImgv.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.coverImgv];
}

-(void)addLock{
    CALayer *lockBGlayer = [[CALayer alloc] init];
    lockBGlayer.frame = self.bounds;
    lockBGlayer.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:.5].CGColor;
    [self.layer addSublayer:lockBGlayer];
}

-(void)addTitleLabel{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(16,12,self.frame.size.width-16-32-16,28);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:20];
    [self addSubview:self.titleLabel];
}

-(void)addSubTitleLabel{
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.frame = CGRectMake(16,CGRectGetMaxY(self.titleLabel.frame),self.frame.size.width-32,22);
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    [self addSubview:self.subTitleLabel];
}

-(void)addLockImage{
    UIImageView *lockImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lock-w"]];
    lockImage.center = CGPointMake(GET_SCREEN_WIDTH/2-20*SCALE, self.bounds.size.height/2);
    [self addSubview:lockImage];
}


-(void)setSession:(YGSession *)session{
    if (session!=_session) {
        _session = session;
        self.titleLabel.text = session.title;
        self.subTitleLabel.text = [NSString stringWithFormat:@"%@ MINUTES",session.duration];
        [self.coverImgv setImageWithURL:[NSURL URLWithString:session.coverImg.coverUrl] placeholderImage:[UIImage imageNamed:@"Routine-cover-default.png"]];
    }
    self.favorateBtn.selected = session.favorate.boolValue;
}
@end

