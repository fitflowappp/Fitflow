//
//  YGDefaultSessionController.m
//  Yoga
//
//  Created by lyj on 2017/9/21.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGChallenge.h"
#import "YGRoutine.h"
#import "YGSession.h"
#import "YGStringUtil.h"
#import "YGTextHeader.h"
#import "YGRoutineCell.h"
#import "YGRefreshHeader.h"
#import "YGPlayController.h"
#import "YGNetworkService.h"
#import "UIColor+Extension.h"
#import "YGSession+Extension.h"
#import "YGSessionBannerCell.h"
#import "YGSessionController.h"
#import "YGSessionLockedFooter.h"
#import "YGSessionUnlockedFooter.h"
#import "YGDefaultSessionController.h"
#import "YGAppDelegate.h"
#import "YGChallengeService.h"
static NSString *ROUTINE_CELLID    = @"routineCellID";

static NSString *SESSION_HEADERID  = @"sessionHeaderID";

static NSString *SESSION_BANNER_CELLID   = @"sessionBannerCellID";

static NSString *SESSION_LOCKED_FOOTERID    = @"sessionLockedFooterID";

static NSString *SESSION_UNLOCKED_FOOTERID  = @"sessionUnlockedFooterID";
@interface YGDefaultSessionController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) YGChallenge *currentChallenge;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation YGDefaultSessionController{
    YGSession *defaultSession;
}

#pragma mark Life-Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSkipItem];
    [self setCollectionView];
    [self setLeftNavigationItem];
    [YGHUD loading:self.view];
}

-(void)setSkipItem{
    UIButton *skipItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    skipItemBtn.frame = CGRectMake(0,0,31*SCALE,60);
    [skipItemBtn setTitle:@"Skip" forState:UIControlStateNormal];
    [skipItemBtn setTitleColor:[UIColor colorWithHexString:@"#0DA5F0"] forState:UIControlStateNormal];
    [skipItemBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16*SCALE]];
    [skipItemBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [skipItemBtn addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:skipItemBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self fetchDefaultSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)fetchDefaultSession{
    __weak typeof(self) ws = self;
    [[YGChallengeService instance] fetchUserCurrentChallengeSucessBlock:^(YGChallenge *challenge) {
        if (challenge) {
            ws.currentChallenge = challenge;
            if (ws.currentChallenge.workoutList.count) {
                defaultSession = ws.currentChallenge.workoutList[0];
                ws.navigationItem.title = defaultSession.title;
            }
        }
        [ws endLoading];
    } errorBlock:^(NSError *error) {
        [ws endLoading];
        if (ws.currentChallenge==nil) {
            [YGHUD alertNetworkErrorIn:ws.view target:ws];
        }else{
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
        }
    }];
}

-(void)retryWhenNetworkError{
    [YGHUD loading:self.view];
    [self fetchDefaultSession];
}

-(void)endLoading{
    [YGHUD hide:self.view];
    [self.collectionView reloadData];
    [self.collectionView.mj_header endRefreshing];
}

#pragma mark UI
-(void)setCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.sectionFootersPinToVisibleBounds = YES;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,GET_SCREEN_WIDTH, GET_SCREEN_HEIGHT-NAV_HEIGHT) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.mj_header = [YGRefreshHeader headerAtTarget:self action:@selector(fetchDefaultSession) view:self.collectionView];
    [self.collectionView registerClass:[YGSessionBannerCell class] forCellWithReuseIdentifier:SESSION_BANNER_CELLID];
    [self.collectionView registerClass:[YGRoutineCell class] forCellWithReuseIdentifier:ROUTINE_CELLID];
    [self.collectionView registerClass:[YGTextHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SESSION_HEADERID];
    [self.collectionView registerClass:[YGSessionLockedFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SESSION_LOCKED_FOOTERID];
    [self.collectionView registerClass:[YGSessionUnlockedFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SESSION_UNLOCKED_FOOTERID];
    [self.view addSubview:self.collectionView];
}

#pragma mark UICollection-DataSouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (defaultSession.displayRoutineList.count) {
        return 2;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return section==0?1:defaultSession.displayRoutineList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        YGSessionBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SESSION_BANNER_CELLID forIndexPath:indexPath];
        cell.session = defaultSession;
        //cell.shouldLight = YES;
        return cell;
    }
    YGRoutineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ROUTINE_CELLID forIndexPath:indexPath];
    cell.routine = defaultSession.displayRoutineList[indexPath.row];
//    cell.routineIndex = indexPath.row+1;
//    if (indexPath.row==0) {
//        if ([self collectionView:self.collectionView numberOfItemsInSection:1]==1) {
//            cell.routineIndexType = ROUTINE_INDEX_ONLY_ONE;
//        }else{
//            cell.routineIndexType = ROUTINE_INDEX_TOP;
//        }
//    }else if(indexPath.row==[self collectionView:self.collectionView numberOfItemsInSection:1]-1){
//        cell.routineIndexType = ROUTINE_INDEX_BOTTOM;
//        
//    }else{
//        cell.routineIndexType = ROUTINE_INDEX_CENTER;
//    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YGTextHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SESSION_HEADERID forIndexPath:indexPath];
        header.text = defaultSession.attributedDescription;
        return header;
    }else{
        YGSessionUnlockedFooter *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SESSION_UNLOCKED_FOOTERID forIndexPath:indexPath];
        SEL action = @selector(playVideo);
        if ([header.playVedioBtn respondsToSelector:action]==NO) {
            [header.playVedioBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        }
        return header;
    }
}

#pragma mark UICollectionView-Layout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat scale = self.scale;
    return section==0?UIEdgeInsetsMake(8*scale,16*scale,16*scale,16*scale):UIEdgeInsetsMake(8*scale,16*scale,68*scale,16*scale);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat retW = collectionView.frame.size.width-16*SCALE*2;
    return CGSizeMake(retW,indexPath.section==0?retW*((float)386/686.0):retW*(128/686.0));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size = CGSizeZero;
    if (section>0) {
        if (defaultSession.decriptionHeight.floatValue) {
            size = CGSizeMake(collectionView.frame.size.width,defaultSession.decriptionHeight.floatValue);
        }else{
            NSString *string = defaultSession.sessionDescription;
            if ([YGStringUtil notNull:string]) {
                NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:string];
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.tailIndent = -16*SCALE;
                style.headIndent = 16*SCALE;
                style.firstLineHeadIndent = 16*SCALE;
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setObject:[UIColor colorWithHexString:@"#4A4A4A"] forKey:NSForegroundColorAttributeName];
                [params setObject:[UIFont fontWithName:@"Lato-Regular" size:16*SCALE] forKey:NSFontAttributeName];
                [params setObject:style forKey:NSParagraphStyleAttributeName];
                [aString addAttributes:params range:NSMakeRange(0,string.length)];
                size = [YGStringUtil boundString:aString inSize:CGSizeMake(collectionView.frame.size.width,MAXFLOAT)];
                defaultSession.decriptionHeight = @(size.height);
                defaultSession.attributedDescription = aString;
            }
        }
    }
    
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return section==0?CGSizeZero:CGSizeMake(collectionView.frame.size.width,16*SCALE*2+(self.collectionView.frame.size.width-16*SCALE*2*2)*(96/686.0));
    
}

#pragma mark method

-(void)skip{
    if (defaultSession) {
        NSString *requestUrl = [NSString stringWithFormat:@"%@/yoga/challenge/%@/workout/%@/skip",cRequestDomain,self.currentChallenge.ID,defaultSession.ID];
        [YGHUD loading:self.view];
        [[YGNetworkService instance] networkWithUrl:requestUrl requsetType:PUT successBlock:^(id data) {
            [self jumpToTabBarController];
        } errorBlock:^(NSError *error) {
            [self jumpToTabBarController];
        }];
    }else{
        [self jumpToTabBarController];
    }
}

-(void)jumpToTabBarController{
    [YGHUD hide:self.view];
    YGAppDelegate *delegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate initTabBarController];
}

-(void)playVideo{
    if (defaultSession.routineList.count) {
        YGPlayController *controller = [[YGPlayController alloc] init];
        controller.session =defaultSession;
        controller.challengeID = self.currentChallenge.ID;
        //controller.fromDefaultWorkout = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
@end
