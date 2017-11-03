//
//  YGChanllengeController.m
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGRefreshHeader.h"
#import "YGChallengeCell.h"
#import "YGChallenge+Extension.h"
#import "YGChallengeController.h"
#import "YGCurrentChallengeCell.h"
#import "YGMoreChallengesHeader.h"
#import "YGChallengeListService.h"
#import "YGChallengeListController.h"

static NSString *CHALLENGES_CELLID        = @"challengesCellID";

static NSString *CHALLENGES_HEADERID      = @"challengesHeaderID";

static NSString *CURRENT_CHALLENGE_CELLID = @"currentChallengeCellID";


@interface YGChallengeListController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray   *challengeList;
@end

@implementation YGChallengeListController

#pragma Life-Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollectionView];
    [YGHUD loading:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchChallengeList];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)fetchChallengeList{
    __weak typeof(self) ws = self;
    [[YGChallengeListService instance] fetchChallengeListSucessBlock:^(NSMutableArray *challengeList) {
        if (challengeList.count) {
            ws.challengeList = challengeList;
        }
        [ws endLoading];
    } errorBlock:^(NSError *error) {
        [ws endLoading];
        if (ws.challengeList.count) {
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view].yOffset=-NAV_HEIGHT/2;
        }else{
            [YGHUD alertNetworkErrorIn:ws.view target:ws].yOffset=-NAV_HEIGHT/2;
        }
    }];
}

-(void)retryWhenNetworkError{
    [YGHUD loading:self.view];
    [self fetchChallengeList];
}

-(void)endLoading{
    [YGHUD hide:self.view];
    [self.collectionView reloadData];
    [self.collectionView.mj_header endRefreshing];
}

#pragma mark UI
-(void)setCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 2;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,GET_SCREEN_WIDTH, GET_SCREEN_HEIGHT-TAB_BAR_HEIGHT) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[YGChallengeCell class] forCellWithReuseIdentifier:CHALLENGES_CELLID];
    [self.collectionView registerClass:[YGCurrentChallengeCell class] forCellWithReuseIdentifier:CURRENT_CHALLENGE_CELLID];
    [self.collectionView registerClass:[YGMoreChallengesHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CHALLENGES_HEADERID];
    self.collectionView.mj_header = [YGRefreshHeader headerAtTarget:self action:@selector(fetchChallengeList) view: self.collectionView];
    [self.view addSubview:self.collectionView];
}

#pragma mark UICollectionView-Datasouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.challengeList.count==1) {
        return 1;
    }
    if (self.challengeList.count>1) {
        return 2;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return section==0?1:self.challengeList.count-1;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YGChallengeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CHALLENGES_CELLID forIndexPath:indexPath];
    if (indexPath.section==0) {
        cell.challenge = self.challengeList[0];
    }else{
        cell.challenge = self.challengeList[indexPath.row+1];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    YGMoreChallengesHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CHALLENGES_HEADERID forIndexPath:indexPath];
    return header;
}

#pragma mark UICollectionView-Layout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return section==0?UIEdgeInsetsMake(36*SCALE,16*SCALE,0,16*SCALE):UIEdgeInsetsMake(0,16*SCALE,36*SCALE,16*SCALE);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat retW = collectionView.frame.size.width-32*SCALE;
    return CGSizeMake(retW,retW*((float)280/686.0)+6);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeZero;
    if (section==1) {
        size = CGSizeMake(collectionView.frame.size.width,64*SCALE);
    }
    return size;
}

#pragma mark UICollectionView-Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YGChallenge *challenge = nil;
    if (indexPath.section==0) {
        challenge = self.challengeList[0];
    }else{
        challenge = self.challengeList [indexPath.row+1];
    }
    YGChallengeController *controller = [[YGChallengeController alloc] init];
    controller.challengeID = challenge.ID;
    controller.hidesBottomBarWhenPushed = YES;
    controller.shouldLigth = challenge.avail.boolValue;
    controller.currentChallenge = [self currentChallenge];
    controller.isMineChallenge = challenge.isMineChallenge.boolValue;
    [self.navigationController pushViewController:controller animated:YES];
}

-(YGChallenge*)currentChallenge{
    YGChallenge *retChallenge = nil;
    for (YGChallenge *challenge in self.challengeList) {
        if (challenge.isMineChallenge.boolValue) {
            retChallenge = challenge;
            break;
        }
    }
    return retChallenge;
}
@end
