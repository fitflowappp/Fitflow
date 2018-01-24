//
//  YGPlayer.m
//  Yoga
//
//  Created by lyj on 2017/9/13.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGPlayer.h"
#import "UIColor+Extension.h"
#import "YGRoutine+Extension.h"
@interface YGPlayer ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong,readonly) AVPlayerLayer *playerLayer;
@property (nonatomic,strong) UIView   *darkv;
@property (nonatomic,strong) UIButton *preBtn;
@property (nonatomic,strong) UIButton *nextBnt;
@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic,strong) UIButton *stopBtn;
@property (nonatomic,strong) UIButton *exitBtn;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *loadingImgv;
@property (nonatomic,strong) UILabel *currentTimeLabel;
@property (nonatomic,strong) UIButton *backgroundMusicBtn;
@property (nonatomic,strong) UICollectionView *progressCollectionView;
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
        if (IS_IPHONE_X) {
            self.frame = CGRectMake(73,0,MAX(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT)-146,MIN(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT));
        }else{
            self.frame = CGRectMake(0,0,MAX(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT),MIN(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT));
        }
        [self setPlayerUI];
        self.backgroundColor = [UIColor clearColor];
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return self;
}

-(instancetype)initWithSession:(YGSession *)session{
    self = [[YGPlayer alloc] init];
    if (self) {
        _session = session;
        self.player = [[AVPlayer alloc] init];
        [self addTimeObserver];
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
    [self removeObserver];
    [self loadAssetWithURL:url];
    AVPlayerItem *playItem= [[AVPlayerItem alloc] initWithAsset:[self loadAssetWithURL:url]];
    [self.player replaceCurrentItemWithPlayerItem:playItem];
    [self addObserver];
    [self play];
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%d/%d)",routine.title,(int)[self.session.routineList indexOfObject:routine]+1,(int)self.session.routineList.count];
    [self.progressCollectionView reloadData];
}

-(AVURLAsset*)loadAssetWithURL:(NSURL *)url{
    __weak typeof(self) ws = self;
    if (self.loadingImgv.isAnimating==NO) {
        [self.loadingImgv startAnimating];
    }
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
    if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        /*加载动画*/
        if ([self.loadingImgv isAnimating]==NO&&self.darkv.alpha==0) {
            [self.loadingImgv startAnimating];
        }
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
    [self addProgressCollectionView];
    [self addNextBtn];
    [self addPreBtn];
    [self addTitleLabel];
    [self addCurrentTimeLabel];
    [self addStopBtn];
    [self addExitBtn];
    [self addPlayBtn];
    [self addBackgroundMusicBtn];
    [self addLoadingImgv];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    _darkv.frame = rect;
    self.loadingImgv.center = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
}

-(void)addDarkv{
    _darkv = [[UIView alloc] init];
    _darkv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _darkv.alpha = 0;
    [self addSubview:_darkv];
}

-(void)addProgressCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.progressCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,MAX(self.frame.size.width,self.frame.size.height),4) collectionViewLayout:layout];
    [self.progressCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"progressCellID"];
    self.progressCollectionView.delegate = self;
    self.progressCollectionView.dataSource = self;
    self.progressCollectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.progressCollectionView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.session.routineList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = self.session.routineList.count;
    return CGSizeMake((collectionView.frame.size.width-(count-1))/(count*1.0),collectionView.frame.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"progressCellID" forIndexPath:indexPath];
    NSInteger currentIndex = [self.session.routineList indexOfObject:self.routine];
    if (indexPath.row<currentIndex) {
        cell.backgroundColor = [UIColor colorWithHexString:@"#41D395"];
    }else if (indexPath.row==currentIndex){
        cell.backgroundColor = [UIColor colorWithHexString:@"#41D395" alpha:0.4];
    }else{
        cell.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    }
    return cell;
}
-(void)addTitleLabel{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24,15,self.frame.size.width-24-150,28)];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#0EC07F"];
    _titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    [self addSubview:_titleLabel];
}

-(void)addCurrentTimeLabel{
    _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(24,43,self.frame.size.width-24-150,44)];
    _currentTimeLabel.textColor = [UIColor colorWithHexString:@"#FFFFFFF"];
    _currentTimeLabel.font = [UIFont fontWithName:@"Lato-Black" size:36];
    [self addSubview:_currentTimeLabel];
}

-(void)addStopBtn{
    _stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _stopBtn.bounds = CGRectMake(0,0,56,56);
    _stopBtn.center = CGPointMake(52,CGRectGetMaxY(self.currentTimeLabel.frame)+12+28);
    _stopBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _stopBtn.layer.masksToBounds = YES;
    _stopBtn.layer.cornerRadius = 28;
    [_stopBtn setImage:[UIImage imageNamed:@"Play-gray"] forState:UIControlStateNormal];
    [_stopBtn addTarget:self action:@selector(didSelectStopBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_stopBtn];
}

-(void)addNextBtn{
    _nextBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBnt.bounds = CGRectMake(0,0,40,40);
    _nextBnt.center = CGPointMake(self.frame.size.width-52,self.frame.size.height-68);
    [_nextBnt setImage:[UIImage imageNamed:@"Play-next-white"] forState:UIControlStateNormal];
    [_nextBnt addTarget:self action:@selector(didSelectNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextBnt];
}

-(void)addPreBtn{
    _preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _preBtn.bounds = CGRectMake(0,0,40,40);
    _preBtn.center = CGPointMake(52,self.frame.size.height-68);
    [_preBtn setImage:[UIImage imageNamed:@"Play-pre-white"] forState:UIControlStateNormal];
    [_preBtn addTarget:self action:@selector(didSelectPreBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_preBtn];
}

-(void)addExitBtn{
    _exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _exitBtn.alpha = 0;
    _exitBtn.bounds = CGRectMake(0,0,72,72);
    _exitBtn.layer.masksToBounds = YES;
    _exitBtn.layer.cornerRadius = 36;
    _exitBtn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    _exitBtn.center = CGPointMake(self.frame.size.width/2-72,self.center.y);
    [_exitBtn setImage:[UIImage imageNamed:@"Play-exit"] forState:UIControlStateNormal];
    [_exitBtn addTarget:self action:@selector(didSelectExitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_exitBtn];
}

-(void)addPlayBtn{
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn.alpha = 0;
    _playBtn.bounds = CGRectMake(0,0,72,72);
    _playBtn.layer.masksToBounds = YES;
    _playBtn.layer.cornerRadius = 36;
    _playBtn.backgroundColor = [UIColor colorWithHexString:@"#41D395"];
    _playBtn.center = CGPointMake(self.frame.size.width/2+72,self.center.y);
    [_playBtn setImage:[UIImage imageNamed:@"Play-stop"] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(didSelectPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playBtn];
}

-(void)addBackgroundMusicBtn{
    _backgroundMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backgroundMusicBtn.bounds = CGRectMake(0,0,40,40);
    _backgroundMusicBtn.layer.masksToBounds = YES;
    _backgroundMusicBtn.layer.cornerRadius = 20;
    _backgroundMusicBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _backgroundMusicBtn.center = CGPointMake(self.frame.size.width-52,52);
    [_backgroundMusicBtn setImage:[UIImage imageNamed:@"Play-music-gray"] forState:UIControlStateNormal];
    [_backgroundMusicBtn addTarget:self action:@selector(disSelectSetBackgroundMusicBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backgroundMusicBtn];
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
    [self.delegate openBackgroundMusic];
}

-(void)pause{
    [self.player pause];
    [self showSubviewsIfPause];
    [self.loadingImgv stopAnimating];
    [self.delegate closeBackGroundMusic];
}

-(void)stop{
    [self removeObserver];
    if (self.player) {
        [self.player removeTimeObserver:playbackTimerObserver];
        self.player = nil;
    }
    [self pause];
    [self removeFromSuperview];
}

-(void)didSelectStopBtn:(UIButton*)sender{
    [self pause];
    [self.delegate pauseRoutineNetwork:self.routine];
}

-(void)didSelectPlayBtn:(UIButton*)sender{
    BOOL shouldPlayLastRoutine = NO;
    if (self.session.routineList.lastObject==self.routine){
        if (self.duration&&self.duration-self.currentSeconds==0) {
            shouldPlayLastRoutine = YES;
        }
    }
    if (shouldPlayLastRoutine==YES) {
        [self.player.currentItem seekToTime:kCMTimeZero];
        [self play];
    }else{
        [self.loadingImgv startAnimating];
        [self play];
    }
}

-(void)didSelectExitBtn:(UIButton*)sender{
    [self stop];
    [self.delegate exit];
}

-(void)didSelectNextBtn:(UIButton*)sender{
    [self.delegate skipRoutineNetwork:self.routine];
    [self.delegate nextRoutine];
}

-(void)didSelectPreBtn:(UIButton*)sender{
    [self.delegate preRoutine];
}

-(void)disSelectSetBackgroundMusicBtn:(UIButton*)sender{
    [self.delegate setBackGroundMusic];
}
-(void)showSubviewsIfPause{
    [UIView animateWithDuration:0.2 animations:^{
        _darkv.alpha = 1;
        _exitBtn.alpha = 1;
        _playBtn.alpha = 1;
        _stopBtn.alpha = 0;
        _currentTimeLabel.alpha =0;
        _preBtn.alpha = 0;
        _nextBnt.alpha = 0;
        _backgroundMusicBtn.alpha = 0;
    }];
}

-(void)hidenSubviewsIfPlay{
    [UIView animateWithDuration:0.2 animations:^{
        _darkv.alpha = 0;
        _exitBtn.alpha = 0;
        _playBtn.alpha = 0;
        _stopBtn.alpha = 1;
        _currentTimeLabel.alpha = 1;
        _preBtn.alpha = 1;
        _nextBnt.alpha = 1;
        _backgroundMusicBtn.alpha = 1;
    }];
}

-(void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlay) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    //监听播放的区域缓存是否为空
    [self.player.currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    //缓存可以播放的时候调用
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeObserver{
    @try{
        [self.player.currentItem  removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [self.player.currentItem  removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    }
    @catch(NSException *exception){
        NSLog(@"exception : %@",exception.reason);
    }
    @finally {
        NSLog(@"...");
    }
}

-(void)endPlay{
    [self.delegate playingToEnd:self.routine];
}

-(void)willResignActive{
    [self pause];
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
