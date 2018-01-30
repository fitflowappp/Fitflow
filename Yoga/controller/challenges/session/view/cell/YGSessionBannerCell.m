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
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UIImageView *coverImgv;
//@property (nonatomic,strong) UIImageView *lockedImgv;
@property (nonatomic,strong) UIButton *favorateBtn;
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
    self.layer.cornerRadius = 8;
    [self addCoverImgv];
    [self addDarkv];
    [self addFavorateBtn];
    [self addTitleLabel];
    [self addSubTitleLabel];
    //[self addLockedImgv];
}

-(void)addCoverImgv{
    self.coverImgv = [[UIImageView alloc] initWithFrame:self.bounds];
    self.coverImgv.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.coverImgv];
}

-(void)addDarkv{
    self.darkv = [[UIView alloc] initWithFrame:self.coverImgv.bounds];
    self.darkv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.coverImgv addSubview:self.darkv];
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

//-(void)addLockedImgv{
//    self.lockedImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lock-w"]];
//    self.lockedImgv.center = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
//    [self addSubview:self.lockedImgv];
//}

-(void)addFavorateBtn{
    self.favorateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.favorateBtn.hidden = YES;
    self.favorateBtn.frame = CGRectMake(self.frame.size.width-16-32,16,32,32);
    [self.favorateBtn setImage:[UIImage imageNamed:@"Single-unfavorate"] forState:UIControlStateNormal];
    [self.favorateBtn setImage:[UIImage imageNamed:@"Single-favorate"] forState:UIControlStateSelected];
    [self.favorateBtn addTarget:self action:@selector(didSelectFavorateBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.favorateBtn];
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

//-(void)setShouldLight:(BOOL)shouldLight{
//    if (shouldLight!=_shouldLight) {
//        _shouldLight = shouldLight;
//        self.darkv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:shouldLight?0.3:0.45];
//        self.lockedImgv.hidden = shouldLight;
//    }
//}

-(void)setShouldFavorate:(BOOL)shouldFavorate{
    if (shouldFavorate!=_shouldFavorate) {
        _shouldFavorate = shouldFavorate;
        if (_shouldFavorate==YES) {
            self.favorateBtn.hidden = NO;
        }else{
            self.favorateBtn.hidden = YES;
        }
    }
}

-(void)didSelectFavorateBtn:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(handleFavorate:)]) {
        BOOL favorate = !sender.selected;
        [self.delegate handleFavorate:favorate];
    }
}
@end
