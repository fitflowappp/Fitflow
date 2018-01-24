//
//  YGChanllengeController.m
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGDeviceUtil.h"
#import "YGRefreshHeader.h"
#import "YGChallengeCell.h"
#import "YGChallenge+Extension.h"
#import "YGChallengeController.h"
#import "YGFirstInstallAlertCell.h"
#import "YGChallengeListService.h"
#import "YGChallengeListController.h"
static NSString *CHALLENGES_CELLID        = @"challengesCellID";
static NSString *FIRST_INSTALL_ALERT_CELLID = @"firstInstallALertCellID";

@interface YGChallengeListController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray   *challengeList;
@property (nonatomic,assign) BOOL hasAlertChallengesTip;
@end

@implementation YGChallengeListController

#pragma Life-Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasAlertChallengesTip = [YGDeviceUtil hasEnteredChallengesInDiscover];
    self.view.frame = CGRectMake(0,0,GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT-NAV_HEIGHT-TAB_BAR_HEIGHT-24);
    [self setCollectionView];
    [YGHUD loading:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchChallengeList];
    [self.collectionView reloadData];
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
    layout.minimumLineSpacing = 1;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[YGChallengeCell class] forCellWithReuseIdentifier:CHALLENGES_CELLID];
    [self.collectionView registerClass:[YGFirstInstallAlertCell class] forCellWithReuseIdentifier:FIRST_INSTALL_ALERT_CELLID];
    self.collectionView.mj_header = [YGRefreshHeader headerAtTarget:self action:@selector(fetchChallengeList) view: self.collectionView];
    [self.view addSubview:self.collectionView];
}

#pragma mark UICollectionView-Datasouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.hasAlertChallengesTip==NO) {
        return 2;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == [self numberOfSectionsInCollectionView:collectionView]-1) {
        return self.challengeList.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == [self numberOfSectionsInCollectionView:collectionView]-1) {
        YGChallengeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CHALLENGES_CELLID forIndexPath:indexPath];
        cell.challenge = self.challengeList[indexPath.row];
        return cell;
    }
    YGFirstInstallAlertCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FIRST_INSTALL_ALERT_CELLID forIndexPath:indexPath];
    cell.text = @"Challenges are 1-4 week programs\nthat help you achieve your goals";
    SEL action = @selector(didSelectCancelChallengesTip:);
    if ([cell.cancelAlertBtn respondsToSelector:action]==NO) {
        [cell.cancelAlertBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

#pragma mark UICollectionView-Layout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (section == [self numberOfSectionsInCollectionView:collectionView]-1) {
        CGFloat maiginTop = 8;
        if ([self numberOfSectionsInCollectionView:collectionView]>1) {
            maiginTop = 0;
        }
        insets = UIEdgeInsetsMake(maiginTop,0,36,0);
    }
    return insets;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat retW = collectionView.frame.size.width;
    CGFloat retH = 0;
    if (indexPath.section == [self numberOfSectionsInCollectionView:collectionView]-1) {
        retH = retW*(153/375.0);
    }else{
        retH = retW*(58/375.0);
    }
    return CGSizeMake(retW,retH);
}

#pragma mark UICollectionView-Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section== [self numberOfSectionsInCollectionView:collectionView]-1) {
        YGChallenge *challenge = self.challengeList[indexPath.row];
        YGChallengeController *controller = [[YGChallengeController alloc] init];
        controller.challengeID = challenge.ID;
        controller.hidesBottomBarWhenPushed = YES;
        controller.shouldLigth = challenge.avail.boolValue;
        controller.userCurrentChallenge = [self currentChallenge];
        controller.isMineChallenge = challenge.isMineChallenge.boolValue;
        [self.navigationController pushViewController:controller animated:YES];
        self.hasAlertChallengesTip = YES;
    }
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

#pragma mark
-(void)didSelectCancelChallengesTip:(UIButton*)sender{
    self.hasAlertChallengesTip = YES;
    [self.collectionView reloadData];
}
@end
