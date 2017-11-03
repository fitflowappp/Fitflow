//
//  YGBeginMyWorkoutPlayer.m
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGBeginMyWorkoutPlayer.h"
@interface YGBeginMyWorkoutPlayer ()
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) UIView      *darkv;
@property (nonatomic,strong) UIImageView *logoImgv;
@property (nonatomic,strong) UIButton    *beginMyworkoutBtn;
@property (nonatomic,strong) UIButton    *alreadyHaveAccountBtn;

@property (nonatomic,strong) UIImageView *openImgv;

@end
@implementation YGBeginMyWorkoutPlayer
+(Class)layerClass{
    return [AVPlayerLayer class];
}
//MARK: Get方法和Set方法
-(AVPlayer *)player{
    return self.playerLayer.player;
}
-(void)setPlayer:(AVPlayer *)player{
    self.playerLayer.player = player;
}
-(AVPlayerLayer *)playerLayer{
    return (AVPlayerLayer *)self.layer;
}

-(id)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0,0,GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT);
        
        
         [self setPlayerUI];
//        self.player = [[AVPlayer alloc] init];
//        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return self;
}

-(instancetype)initWithUrl:(NSURL *)url{
    self = [[YGBeginMyWorkoutPlayer alloc] init];
    if (self) {
        _url = url;
        [self assetWithURL:url];
    }
    return self;
}

-(void)setupPlayerWithAsset:(AVURLAsset *)asset{
    [self removeObserver];
    self.item = [[AVPlayerItem alloc] initWithAsset:asset];
    [self.player replaceCurrentItemWithPlayerItem:self.item];
    [self.playerLayer displayIfNeeded];
    [self addObserver];
}

-(void)assetWithURL:(NSURL *)url{
    NSDictionary *options = @{ AVURLAssetPreferPreciseDurationAndTimingKey : @YES };
    self.anAsset = [[AVURLAsset alloc]initWithURL:url options:options];
    [self setupPlayerWithAsset:self.anAsset];
}

#pragma mark playerUI
-(void)setPlayerUI{
    [self addOpenImgv];
    [self addDarkv];
    [self addLogoImgv];
    [self addBeginMyworkoutBtn];
    [self AddAlreadyHaveAccountBtn];
}

-(void)addOpenImgv{
    self.openImgv = [[UIImageView alloc] initWithFrame:self.frame];
    self.openImgv.image = [UIImage imageNamed:@"open"];
    [self addSubview:self.openImgv];
}

-(void)addDarkv{
    self.darkv = [[UIView alloc] initWithFrame:self.bounds];
    self.darkv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self addSubview:self.darkv];
}

-(void)addLogoImgv{
    self.logoImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo-w"]];
    self.logoImgv.center = CGPointMake(self.frame.size.width/2,(417.0/1334)*self.frame.size.height+self.logoImgv.frame.size.height/2);
    [self addSubview:self.logoImgv];
}

-(void)AddAlreadyHaveAccountBtn{
    CGFloat scale = SCALE;
    CGFloat height = (168.0/1334)*self.frame.size.height;
    self.alreadyHaveAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.alreadyHaveAccountBtn.frame = CGRectMake(0,self.frame.size.height-height,self.frame.size.width,height);
    [self.alreadyHaveAccountBtn setTitle:@"I already have an account" forState:UIControlStateNormal];
    [self.alreadyHaveAccountBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:12*scale]];
    [self.alreadyHaveAccountBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.alreadyHaveAccountBtn addTarget:self action:@selector(didSelectAlreadyHaveAccount) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.alreadyHaveAccountBtn];
}

-(void)addBeginMyworkoutBtn{
    CGFloat scale = SCALE;
    CGFloat margin = 16*scale;
    CGFloat width  = self.frame.size.width-margin*2;
    CGFloat height = width*(96/686.0);
    CGFloat marginBottom = (168.0/1334)*self.frame.size.height;
    self.beginMyworkoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beginMyworkoutBtn.frame = CGRectMake(margin,self.frame.size.height-marginBottom-height,self.frame.size.width-margin*2,height);
    self.beginMyworkoutBtn.layer.masksToBounds = YES;
    self.beginMyworkoutBtn.layer.cornerRadius = self.beginMyworkoutBtn.frame.size.height/2;
    [self.beginMyworkoutBtn setTitle:@"BEGIN MY WORKOUT" forState:UIControlStateNormal];
    [self.beginMyworkoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.beginMyworkoutBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16*scale]];
    [self.beginMyworkoutBtn addTarget:self action:@selector(didSelectBeginMyworkout) forControlEvents:UIControlEventTouchUpInside];
    /*渐变色*/
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#00BCFF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#3ACE8F"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#48DE4D"].CGColor];
    gradientLayer.locations = @[@0.1, @0.6, @0.9];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = self.beginMyworkoutBtn.bounds;
    [self.beginMyworkoutBtn.layer insertSublayer:gradientLayer atIndex:0];
    [self addSubview:self.beginMyworkoutBtn];
}

-(void)play{
    [self.player play];
    CMTime pointTime = CMTimeMake(1,1);
    [self.player seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

-(void)pause{
    [self.player pause];
}

-(void)stop{
    [self removeObserver];
    if (self.player) {
        [self pause];
        self.anAsset = nil;
        self.item = nil;
        self.player = nil;
        [self removeFromSuperview];
    }
}

-(void)becomeActive{
    [self play];
}

-(void)willResignActive{
    [self pause];
}

/*播放结束*/
-(void)endPlay{
    CMTime pointTime = CMTimeMake(1,1);
    [self.player.currentItem seekToTime:pointTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self play];
}
-(void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlay) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)didSelectAlreadyHaveAccount{
    [self.delegate login];
}

-(void)didSelectBeginMyworkout{
    [self.delegate beginMyWorkout];
}

@end
