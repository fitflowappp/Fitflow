//
//  YGPlayer.m
//  Yoga
//
//  Created by lyj on 2017/9/13.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGPlayer.h"
#import "YGRoutine+Extension.h"
@interface YGPlayer ()

@property (nonatomic,strong,readonly) AVPlayerLayer *playerLayer;
@property (nonatomic,strong) UIView   *darkv;
@property (nonatomic,strong) UIButton *preBtn;
@property (nonatomic,strong) UIButton *nextBnt;
@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic,strong) UIButton *exitBtn;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *exitLabel;
@property (nonatomic,strong) UILabel *resumeLabel;
@property (nonatomic,strong) UILabel *restartLabel;
@property (nonatomic,strong) UILabel *currentTimeLabel;
@property (nonatomic,strong) UIImageView *loadingImgv;
@property (nonatomic) float  duration;
@end

@implementation YGPlayer
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
        self.frame = CGRectMake(0,0,MAX(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT),MIN(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT));
        [self setPlayerUI];
        self.backgroundColor = [UIColor clearColor];
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        AVAudioSession *avSession = [AVAudioSession sharedInstance];
        [avSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [avSession setActive:YES error:nil];
        
    }
    return self;
}

-(instancetype)initWithRoutine:(YGRoutine *)routine{
    self = [[YGPlayer alloc] init];
    if (self) {
        _routine = routine;
        NSURL *url = nil;
        if ([routine downLoaded]) {
            url = [NSURL fileURLWithPath:[routine videoInSandboxPath]];
        }else{
            url = [NSURL URLWithString:routine.videoUrl];
        }
        AVPlayerItem *playItem= [[AVPlayerItem alloc] initWithAsset:[self loadAssetWithURL:url]];
        self.player = [[AVPlayer alloc] initWithPlayerItem:playItem];
        [self addObserver];
        [self addTimeObserver];
        [self play];
        self.titleLabel.text = routine.title;
    }
    return self;
}

-(void)playRoutine:(YGRoutine *)routine{
    _routine = routine;
    NSURL *url = nil;
    if ([routine downLoaded]) {
        url = [NSURL fileURLWithPath:[routine videoInSandboxPath]];
    }else{
        url = [NSURL URLWithString:routine.videoUrl];
    }
    [self loadAssetWithURL:url];
    [self removeObserver];
    self.titleLabel.text = routine.title;
    AVPlayerItem *playItem= [[AVPlayerItem alloc] initWithAsset:[self loadAssetWithURL:url]];
    [self.player replaceCurrentItemWithPlayerItem:playItem];
    [self addObserver];
    [self play];
}

-(AVURLAsset*)loadAssetWithURL:(NSURL *)url{
    __weak typeof(self) ws = self;
    [self.loadingImgv startAnimating];
    NSDictionary *options = @{ AVURLAssetPreferPreciseDurationAndTimingKey : @YES };
    AVURLAsset *asset = [[AVURLAsset alloc]initWithURL:url options:options];
    NSArray *keys = @[@"duration"];
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        NSError *error = nil;
        AVKeyValueStatus tracksStatus = [asset statusOfValueForKey:@"duration" error:&error];
        switch (tracksStatus) {
            case AVKeyValueStatusLoaded:
            {
                if (!CMTIME_IS_INDEFINITE(asset.duration)) {
                    ws.duration = asset.duration.value / asset.duration.timescale;
                }
            }
                break;
            default:
                break;
        }
    }];
    return asset;
    
}
/*跟踪时间的改变*/
-(void)addTimeObserver{
    __weak typeof(self) ws = self;
    playbackTimerObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.f, 1.f) queue:NULL usingBlock:^(CMTime time) {
        if (ws.player.currentItem.currentTime.timescale) {
            float seconds = ws.player.currentItem.currentTime.value/ws.player.currentItem.currentTime.timescale;
            ws.currentSeconds = seconds;
            ws.currentTimeLabel.text = [ws convertTime:seconds];
        }
    }];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus itemStatus = [[change objectForKey:NSKeyValueChangeNewKey]integerValue];
        switch (itemStatus) {
            case AVPlayerItemStatusUnknown:
            {
                [self.loadingImgv stopAnimating];
            }
                break;
            case AVPlayerItemStatusReadyToPlay:
            {
                //[YGHUD hide:self];
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                [self.loadingImgv stopAnimating];
                break;
            }
            default:
                break;
        }
    }
    else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        /*加载动画*/
        [self.loadingImgv startAnimating];
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *loadedTimeRanges = [self.player.currentItem loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
        float remainBufferSeconds = CMTimeGetSeconds(timeRange.duration);
        if (remainBufferSeconds>5) {
            [self.loadingImgv stopAnimating];
        }
    }
}

#pragma mark playerUI

-(void)setPlayerUI{
    [self addDarkv];
    [self addPlayBtn];
    [self addNextBtn];
    [self addPreBtn];
    [self addExitBtn];
    [self addResumeLabel];
    [self addRestartLabel];
    [self addExitLabel];
    [self addTitleLabel];
    [self addCurrentTimeLabel];
    [self addLoadingImgv];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    _darkv.frame = rect;
    /**/
    _currentTimeLabel.frame = CGRectMake(32,0,150,44);
    _playBtn.center = CGPointMake(rect.size.width-_playBtn.bounds.size.width-32,rect.size.height-_playBtn.bounds.size.height/2-24);
    _currentTimeLabel.center = CGPointMake(_currentTimeLabel.center.x,_playBtn.center.y);
    _nextBnt.center = CGPointMake(_playBtn.center.x,_playBtn.center.y-_nextBnt.bounds.size.height/2-_nextBnt.frame.size.height/2-24);
    _preBtn.center =CGPointMake(_playBtn.center.x,_nextBnt.center.y-_preBtn.bounds.size.height/2-_nextBnt.frame.size.height/2-24);
    
    _exitBtn.center = CGPointMake(_playBtn.center.x,24+_exitBtn.frame.size.height/2);
    /**/
    _resumeLabel.frame = CGRectMake(_playBtn.frame.origin.x-16-150,_playBtn.frame.origin.y,150,_playBtn.frame.size.height);
    _restartLabel.frame = CGRectMake(_nextBnt.frame.origin.x-16-150,_nextBnt.frame.origin.y,150,_nextBnt.frame.size.height);
    _exitLabel.frame = CGRectMake(_exitBtn.frame.origin.x-16-100,_exitBtn.frame.origin.y,100,_exitBtn.frame.size.height);
    _titleLabel.frame = CGRectMake(32,0,_exitLabel.frame.origin.x-32,20);
    _titleLabel.center = CGPointMake(_titleLabel.center.x,_exitLabel.center.y);
    self.loadingImgv.center = self.center;
}

-(void)addDarkv{
    _darkv = [[UIView alloc] init];
    _darkv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    _darkv.alpha = 0;
    [self addSubview:_darkv];
}

-(void)addTitleLabel{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    [self addSubview:_titleLabel];
}

-(void)addCurrentTimeLabel{
    _currentTimeLabel = [[UILabel alloc] init];
    _currentTimeLabel.textColor = [UIColor whiteColor];
    _currentTimeLabel.font = [UIFont fontWithName:@"Lato-Black" size:36];
    [self addSubview:_currentTimeLabel];
}

-(void)addPlayBtn{
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn.bounds = CGRectMake(0,0,48,48);
    [_playBtn setImage:[UIImage imageNamed:@"Play-white"] forState:UIControlStateNormal];
    [_playBtn setImage:[UIImage imageNamed:@"Pause-white"] forState:UIControlStateSelected];
    [_playBtn addTarget:self action:@selector(didSelectPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playBtn];
}

-(void)addNextBtn{
    _nextBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBnt.bounds = CGRectMake(0,0,48,48);
    [_nextBnt setImage:[UIImage imageNamed:@"Next-white"] forState:UIControlStateNormal];
    [_nextBnt setImage:[UIImage imageNamed:@"Restart-white"] forState:UIControlStateSelected];
    [_nextBnt addTarget:self action:@selector(didSelectNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextBnt];
}

-(void)addPreBtn{
    _preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _preBtn.bounds = CGRectMake(0,0,48,48);
    [_preBtn setImage:[UIImage imageNamed:@"Previous-white"] forState:UIControlStateNormal];
    [_preBtn addTarget:self action:@selector(didSelectPreBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_preBtn];
}

-(void)addExitBtn{
    _exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _exitBtn.alpha = 0;
    _exitBtn.bounds = CGRectMake(0,0,48,48);
    [_exitBtn setImage:[UIImage imageNamed:@"Exit-white"] forState:UIControlStateNormal];
    [_exitBtn addTarget:self action:@selector(didSelectExitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_exitBtn];
}

-(void)addResumeLabel{
    _resumeLabel = [[UILabel alloc] init];
    _resumeLabel.text = @"Resume";
    _resumeLabel.alpha = 0;
    _resumeLabel.textColor = [UIColor whiteColor];
    _resumeLabel.textAlignment = NSTextAlignmentRight;
    _resumeLabel.font = [UIFont fontWithName:@"Lato-Semibold" size:16];
    [self addSubview:_resumeLabel];
}
-(void)addRestartLabel{
    _restartLabel = [[UILabel alloc] init];
    _restartLabel.alpha = 0;
    _restartLabel.text = @"Restart";
    _restartLabel.textColor = [UIColor whiteColor];
    _restartLabel.textAlignment = NSTextAlignmentRight;
    _restartLabel.font = [UIFont fontWithName:@"Lato-Semibold" size:16];
    [self addSubview:_restartLabel];
    
}

-(void)addExitLabel{
    _exitLabel = [[UILabel alloc] init];
    _exitLabel.text = @"Exit";
    _exitLabel.alpha = 0;
    _exitLabel.textColor = [UIColor whiteColor];
    _exitLabel.textAlignment = NSTextAlignmentRight;
    _exitLabel.font = [UIFont fontWithName:@"Lato-Semibold" size:16];
    [self addSubview:_exitLabel];
}

-(void)addLoadingImgv{
    self.loadingImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,32,32)];
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1;i<9;i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"loading-%0.2d",i]];
        [images addObject:img];
    }
    self.loadingImgv.contentMode = UIViewContentModeScaleAspectFit;
    self.loadingImgv.animationImages = images;
    self.loadingImgv.animationRepeatCount = (int)MAXFLOAT;
    self.loadingImgv.animationDuration = 0.8;
    [self addSubview:self.loadingImgv];
}

-(void)play{
    [self.player play];
    [self hidenSubviewsIfPlay];
    self.playBtn.selected = YES;
    self.nextBnt.selected = NO;
}

-(void)pause{
    [self.player pause];
    [self showSubviewsIfPause];
    self.playBtn.selected = NO;
    self.nextBnt.selected = YES;
    [self.loadingImgv stopAnimating];
}

-(void)stop{
    [self removeObserver];
    if (self.player) {
        [self.player removeTimeObserver:playbackTimerObserver];
        self.player = nil;
    }
    if (self.playBtn.selected==NO) {
        [self pause];
    }
    [self removeFromSuperview];
}
-(void)willResignActive{
    [self pause];
    [self.delegate pauseRoutineNetwork:self.routine];
}
-(void)didSelectPlayBtn:(UIButton*)sender{
    if (sender.selected==NO) {
        [self play];
    }else{
        [self pause];
        [self.delegate pauseRoutineNetwork:self.routine];
    }
}

-(void)didSelectExitBtn:(UIButton*)sender{
    [self.delegate exit];
}

-(void)didSelectNextBtn:(UIButton*)sender{
    if (sender.selected) {
        [self.delegate restart];
    }else{
        [self.delegate skipRoutineNetwork:self.routine];
        [self.delegate nextRoutine];
    }
}

-(void)didSelectPreBtn:(UIButton*)sender{
    [self.delegate preRoutine];
}

-(void)showSubviewsIfPause{
    [UIView animateWithDuration:0.3 animations:^{
        _darkv.alpha = 1;
        _exitBtn.alpha = 1;
        _exitLabel.alpha = 1;
        _titleLabel.alpha = 1;
        _resumeLabel.alpha = 1;
        _restartLabel.alpha = 1;
        _preBtn.alpha = 0;
    }];
}

-(void)hidenSubviewsIfPlay{
    [UIView animateWithDuration:0.3 animations:^{
        _darkv.alpha = 0;
        _exitBtn.alpha = 0;
        _exitLabel.alpha = 0;
        _titleLabel.alpha = 0;
        _resumeLabel.alpha = 0;
        _restartLabel.alpha = 0;
        _preBtn.alpha = 1;
    }];
}

-(void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlay) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    //监听状态属性
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监听播放的区域缓存是否为空
    [self.player.currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    //缓存可以播放的时候调用
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeObserver{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem  removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.player.currentItem  removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

-(void)endPlay{
    [self.delegate playingToEnd:self.routine];
}

-(void)failedEndPlay{
    
}
/*将数值转换成时间*/
- (NSString *)convertTime:(float)second{
    float remainSecond = self.duration-second;
    if (remainSecond<0) {
        remainSecond=0;
    }
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:remainSecond];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}
@end
