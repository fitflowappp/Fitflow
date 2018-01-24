//
//  YGPlayBackgroundMusicController.m
//  Yoga
//
//  Created by lyj on 2018/1/15.
//  Copyright © 2018年 lyj. All rights reserved.
//
#import "YGAppDelegate.h"
#import "UIColor+Extension.h"
#import "YGNetworkService.h"
#import "YGBackgroundMusicService.h"
#import "YGBackgroundMusicVolume.h"
#import "YGPlayBackgroundMusicController.h"
static BOOL        musicOpen;
static float       musicVolume;
static NSInteger   musicItemIndex;
@interface YGPlayBackgroundMusicController ()
@property (nonatomic,strong) UIButton *switchBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *classicItemBtn;
@property (nonatomic,strong) UIButton *relaxingItemBtn;
@property (nonatomic,strong) UIButton *energeticItemBtn;
@property (nonatomic,strong) UIButton *switchBackgroundBtn;
@property (nonatomic,strong) YGBackgroundMusicVolume *volumeSlider;
@property (nonatomic) BOOL shouldSyBackgroundMusicSettings;
@end

@implementation YGPlayBackgroundMusicController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    YGAppDelegate *appDelegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.forceLandscape = YES;
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
    musicOpen = [YGBackgroundMusicService isBackgroundMusicOpen];
    musicVolume = [YGBackgroundMusicService currentBackgroundMusicVolume];
    musicItemIndex = [YGBackgroundMusicService currentBackgroundMusicType];
    [self reloadDataViewWillAppear];
}

-(void)dealloc{
    if (self.shouldSyBackgroundMusicSettings) {
        [self startBackgroundMusicSettingNetwork];
    }
}

-(void)setUpSubviews{
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self addCancelBtn];
    [self addRelaxingItemBtn];
    [self addClassicItemBtn];
    [self addEnergeticItemBtn];
    [self addBackgroundMusicSwith];
    [self addBackgroundMusicVolumeSlider];
}

-(void)addCancelBtn{
    CGFloat marginY = 32;
    CGFloat marginX = MAX(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT)-32-32;
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(marginX,marginY,32,32);
    self.cancelBtn.backgroundColor = [UIColor whiteColor];
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 16;
    [self.cancelBtn setImage:[UIImage imageNamed:@"Cancel-green"] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
}

-(void)addBackgroundMusicSwith{
    CGFloat maginY = 76*SCALE+24;
    CGFloat marginX = (MAX(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT)-88)/2.0;
    self.switchBackgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchBackgroundBtn.frame = CGRectMake(marginX,maginY,88,48);
    self.switchBackgroundBtn.layer.masksToBounds = YES;
    self.switchBackgroundBtn.layer.cornerRadius = 24;
    self.switchBackgroundBtn.backgroundColor = [UIColor colorWithHexString:@"#414142"];
    [self.view addSubview:self.switchBackgroundBtn];
    //
    UILabel *offTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.switchBackgroundBtn.frame.origin.x-72,maginY,72,48)];
    offTipLabel.text = @"Off";
    offTipLabel.textAlignment = NSTextAlignmentCenter;
    offTipLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    offTipLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:offTipLabel];
    //
    UILabel *onTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.switchBackgroundBtn.frame),maginY,72,48)];
    onTipLabel.text = @"On";
    onTipLabel.textAlignment = NSTextAlignmentCenter;
    onTipLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    onTipLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:onTipLabel];
    //
    self.switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchBtn.bounds = CGRectMake(0,0,40,40);
    self.switchBtn.layer.masksToBounds = YES;
    self.switchBtn.layer.cornerRadius = 20;
    [self.switchBtn setImage:[UIImage imageNamed:@"Play-music"] forState:UIControlStateNormal];
    [self.switchBtn setBackgroundImage:[UIColor imageWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
    [self.switchBtn setBackgroundImage:[UIColor imageWithHexString:@"#41D395"] forState:UIControlStateSelected];
    [self.switchBackgroundBtn addSubview:self.switchBtn];
    [self.switchBtn addTarget:self action:@selector(handleBackgroundMusicSwithStatus) forControlEvents:UIControlEventTouchUpInside];
    [self.switchBackgroundBtn addTarget:self action:@selector(handleBackgroundMusicSwithStatus) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addBackgroundMusicVolumeSlider{
    CGFloat distance = self.relaxingItemBtn.frame.origin.y-CGRectGetMaxY(self.switchBackgroundBtn.frame);
    CGFloat volumeMarginY = CGRectGetMaxY(self.switchBackgroundBtn.frame)+(distance-25-15-12)/2.0;
    UILabel *volumeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,volumeMarginY,MAX(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT),25)];
    volumeTipLabel.text = @"VOLUME";
    volumeTipLabel.textAlignment = NSTextAlignmentCenter;
    volumeTipLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    volumeTipLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:volumeTipLabel];
    //
    self.volumeSlider = [[YGBackgroundMusicVolume alloc] initWithFrame:CGRectMake((GET_SCREEN_WIDTH-224)/2.0,CGRectGetMaxY(volumeTipLabel.frame)+15, 224,12)];
    [self.volumeSlider addTarget:self action:@selector(volumeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.volumeSlider addTarget:self action:@selector(volumeSliderValueChangedEnd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.volumeSlider];
}

-(void)addRelaxingItemBtn{
    CGFloat centerX = MAX(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT)/2.0;
    CGFloat centerY = MIN(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT)-22-76*SCALE;
    self.relaxingItemBtn = [self creatBackgroundMusicItemBtn];
        self.relaxingItemBtn.tag = 10001;
    self.relaxingItemBtn.center = CGPointMake(centerX,centerY);
    [self.relaxingItemBtn setTitle:@"Relaxing" forState:UIControlStateNormal];
    [self.relaxingItemBtn addTarget:self action:@selector(didSelectBackgroundMusicItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.relaxingItemBtn];
}

-(void)addClassicItemBtn{
    self.classicItemBtn = [self creatBackgroundMusicItemBtn];
    self.classicItemBtn.tag = 10000;
    self.classicItemBtn.center = CGPointMake(self.relaxingItemBtn.frame.origin.x-22-61,self.relaxingItemBtn.center.y);
    [self.classicItemBtn setTitle:@"Classic" forState:UIControlStateNormal];
    [self.classicItemBtn addTarget:self action:@selector(didSelectBackgroundMusicItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.classicItemBtn];
}

-(void)addEnergeticItemBtn{
    self.energeticItemBtn = [self creatBackgroundMusicItemBtn];
    self.energeticItemBtn.tag = 10002;
    self.energeticItemBtn.center = CGPointMake(CGRectGetMaxX(self.relaxingItemBtn.frame)+22+61,self.relaxingItemBtn.center.y);
    [self.energeticItemBtn setTitle:@"Energetic" forState:UIControlStateNormal];
    [self.energeticItemBtn addTarget:self action:@selector(didSelectBackgroundMusicItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.energeticItemBtn];
}

-(UIButton*)creatBackgroundMusicItemBtn{
    UIButton *backgroundMusicItem = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundMusicItem.bounds = CGRectMake(0,0,122,44);
    backgroundMusicItem.layer.masksToBounds = YES;
    backgroundMusicItem.layer.cornerRadius = 22;
    backgroundMusicItem.adjustsImageWhenHighlighted = NO;
    [backgroundMusicItem.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
    [backgroundMusicItem setBackgroundImage:[UIColor imageWithHexString:@"#41D395"] forState:UIControlStateSelected];
    [backgroundMusicItem setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
    return backgroundMusicItem;
}
#pragma mark
-(void)handleBackgroundMusicSwithStatus{
    CGFloat switchCenterX;
    BOOL shouldOpen = !self.switchBtn.selected;
    if (shouldOpen) {
        switchCenterX = self.switchBackgroundBtn.frame.size.width-self.switchBtn.frame.size.width/2.0-4;
    }else{
        switchCenterX = 4+self.switchBtn.frame.size.width/2.0;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.switchBtn.center = CGPointMake(switchCenterX,self.switchBackgroundBtn.frame.size.height/2.0);
    }];
    if (shouldOpen==YES) {
        [self.playerController playBackgroundMusic];
    }else{
        [self.playerController pauseBackgroundMusic];
    }
    self.switchBtn.selected = shouldOpen;
    musicOpen = shouldOpen;
    [self reloadDataIfBackgroundMusicSwitchChanged];
    [YGBackgroundMusicService setBackgroundMusicOpen:shouldOpen];
    if (shouldOpen==YES) {
        [self.playerController playBackgroundMusic];
    }
    self.shouldSyBackgroundMusicSettings = YES;
}

-(void)volumeSliderValueChanged:(UISlider*)slider{
    musicVolume = slider.value;
    [self.playerController setBackGroundMusicVolume:musicVolume];
}

-(void)volumeSliderValueChangedEnd:(UISlider*)slider{
    musicVolume = slider.value;
    [YGBackgroundMusicService setBackgroundMusicVolume:musicVolume];
    self.shouldSyBackgroundMusicSettings = YES;
}
-(void)didSelectBackgroundMusicItem:(UIButton*)sender{
    if (self.switchBtn.selected==YES&&sender.selected==NO) {
        sender.selected = YES;
        NSInteger index = sender.tag-10000;
        if (index==0) {
            self.relaxingItemBtn.selected = NO;
            self.energeticItemBtn.selected = NO;
        }else if (index==1){
            self.classicItemBtn.selected = NO;
            self.energeticItemBtn.selected = NO;
        }else{
            self.classicItemBtn.selected = NO;
            self.relaxingItemBtn.selected = NO;
        }
        musicItemIndex = index;
        [YGBackgroundMusicService setBackgroundMusicType:index];
        [self.playerController playBackgroundMusicItemIndex:index];
        [self.playerController playBackgroundMusic];
        self.shouldSyBackgroundMusicSettings = YES;
    }
}

-(void)cancel{
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark
-(void)reloadDataViewWillAppear{
    CGFloat switchCenterX;
    if (musicOpen==NO) {
        switchCenterX = 4+self.switchBtn.frame.size.width/2.0;
    }else{
        switchCenterX = self.switchBackgroundBtn.frame.size.width-self.switchBtn.frame.size.width/2.0-4;
    }
    self.switchBtn.selected = musicOpen;
    self.volumeSlider.value = musicVolume;
    self.switchBtn.center = CGPointMake(switchCenterX,self.switchBackgroundBtn.frame.size.height/2.0);
    [self reloadDataIfBackgroundMusicSwitchChanged];
}
-(void)reloadDataIfBackgroundMusicSwitchChanged{
    if (musicOpen) {
        [self.classicItemBtn setBackgroundImage:[UIColor imageWithHexString:@"#F8F5F3"] forState:UIControlStateNormal];
        [self.classicItemBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
        [self.relaxingItemBtn setBackgroundImage:[UIColor imageWithHexString:@"#F8F5F3"] forState:UIControlStateNormal];
        [self.relaxingItemBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
        [self.energeticItemBtn setBackgroundImage:[UIColor imageWithHexString:@"#F8F5F3"] forState:UIControlStateNormal];
        [self.energeticItemBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
        if (musicItemIndex==0) {
            self.classicItemBtn.selected = YES;
        }else if (musicItemIndex==1){
            self.relaxingItemBtn.selected = YES;
        }else{
            self.energeticItemBtn.selected = YES;
        }
    }else{
        [self.classicItemBtn setBackgroundImage:[UIColor imageWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
        [self.classicItemBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.relaxingItemBtn setBackgroundImage:[UIColor imageWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
        [self.relaxingItemBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.energeticItemBtn setBackgroundImage:[UIColor imageWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
        [self.energeticItemBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.classicItemBtn.selected = NO;
        self.relaxingItemBtn.selected = NO;
        self.energeticItemBtn.selected = NO;
    }
    self.volumeSlider.light = musicOpen;
}

#pragma mark

-(void)startBackgroundMusicSettingNetwork{
    NSString *requsetURL =URLForge(@"/user/background/music");
    NSDictionary *params = @{@"status":[NSString stringWithFormat:@"%@",@(musicOpen)],
                             @"volume":[NSString stringWithFormat:@"%@",@(musicVolume)],
                             @"musicType":[NSString stringWithFormat:@"%@",@(musicItemIndex)]
                             };
    [[YGNetworkService instance] networkWithUrl:requsetURL requsetType:POST params:params successBlock:^(id data) {
        NSLog(@"msg: psot backgroundMusicSettings network sucess");
    } errorBlock:^(NSError *error) {
        NSLog(@"msg: %@",error.localizedDescription);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
