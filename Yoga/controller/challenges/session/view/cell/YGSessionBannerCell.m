//
//  YGSessionBannerCell.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIImageView+AFNetworking.h"
#import "YGSessionBannerCell.h"
@interface YGSessionBannerCell()
@property (nonatomic,strong) UIView  *darkv;
@property (nonatomic,strong) UIImageView *coverImgv;
@property (nonatomic,strong) UIImageView *lockedImgv;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;

@end

@implementation YGSessionBannerCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSessionBannerCell];
    }
    return self;
}

-(void)setSessionBannerCell{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    [self addCoverImgv];
    [self addDarkv];
    [self addTitleLabel];
    [self addSubTitleLabel];
    [self addLockedImgv];
}

-(void)addCoverImgv{
    self.coverImgv = [[UIImageView alloc] initWithFrame:self.bounds];
    self.coverImgv.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.coverImgv];
}

-(void)addDarkv{
    self.darkv = [[UIView alloc] initWithFrame:self.coverImgv.bounds];
    [self.coverImgv addSubview:self.darkv];
}

-(void)addTitleLabel{
    CGFloat centerY = self.frame.size.height/2;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(0,centerY-4*SCALE-29*SCALE,self.frame.size.width,29*SCALE);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:24*SCALE];
    [self addSubview:self.titleLabel];
}

-(void)addSubTitleLabel{
    CGFloat centerY = self.frame.size.height/2;
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.frame = CGRectMake(0,centerY+4*SCALE,self.frame.size.width,17*SCALE);
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14*SCALE];
    [self addSubview:self.subTitleLabel];
}

-(void)addLockedImgv{
    self.lockedImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lock-w"]];
    self.lockedImgv.center = CGPointMake(self.frame.size.width/2,CGRectGetMaxY(self.subTitleLabel.frame)+22*SCALE+self.lockedImgv.frame.size.height/2);
    [self addSubview:self.lockedImgv];
}

-(void)setSession:(YGSession *)session{
    if (session!=_session) {
        _session = session;
        self.titleLabel.text = session.title;
        self.subTitleLabel.text = [NSString stringWithFormat:@"%@ MINUTES",session.duration];
        [self.coverImgv setImageWithURL:[NSURL URLWithString:session.coverImg.coverUrl] placeholderImage:nil];
    }
}

-(void)setShouldLight:(BOOL)shouldLight{
    self.darkv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:shouldLight?0.3:0.45];
    self.lockedImgv.hidden = shouldLight;
}
@end
