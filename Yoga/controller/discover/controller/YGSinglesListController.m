//
//  YGSinglesListController.m
//  Yoga
//
//  Created by lyj on 2018/1/2.
//  Copyright © 2018年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGSingleCell.h"
#import "YGRefreshHeader.h"
#import "YGSessionService.h"
#import "YGPlayController.h"
#import "YGSessionController.h"
#import "YGSinglesListController.h"
#import "YGFirstInstallAlertCell.h"
#import "YGLockSingleCell.h"
#import "YGDeviceUtil.h"
#import "YGOpenReminderAlert.h"
#import "YGSchedulingController.h"
#import <EventKit/EventKit.h>
#import <MJRefresh/MJRefresh.h>

static NSString *SINGLES_CELLID = @"singlesCellID";
static NSString *FIRST_INSTALL_ALERT_CELLID = @"firstInstallALertCellID";
static NSString *LockSingleCell = @"YGLockSingleCell";

@interface YGSinglesListController ()<UICollectionViewDelegate,UICollectionViewDataSource,YGSingleCellDelegate,YGPlayBaseControllerDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray   *singlesList;
@property (nonatomic,assign) BOOL hasAlertSinglesTip;
@property (nonatomic) NSInteger pageNum;
@end

@implementation YGSinglesListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.singlesList = [NSMutableArray array];
    self.hasAlertSinglesTip = [YGDeviceUtil hasEnteredSinglesInDiscover];
    self.view.frame = CGRectMake(GET_SCREEN_WIDTH,0,GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT-NAV_HEIGHT-TAB_BAR_HEIGHT-24);
    [self setupCollectionView];
    [YGHUD loading:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchSinglesList];
    [self.collectionView reloadData];
}

-(void)fetchSinglesList {
    
    self.pageNum = 0;
    
    [[YGSessionService instance] fetchLockSinglesListPageNum:_pageNum SucessBlock:^(id data) {
        if (data) {
            [self.singlesList removeAllObjects];
            [self.singlesList addObjectsFromArray:data];
            [self.collectionView reloadData];
            self.collectionView.mj_footer.hidden = NO;
        }
        [self.collectionView.mj_footer resetNoMoreData];
        [self endLoading];
    } errorBlock:^(NSError *error) {
        [self endLoading];
        self.pageNum = 0;
        if (self.singlesList.count) {
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:self.view].yOffset=-NAV_HEIGHT/2;
        }else{
            [YGHUD alertNetworkErrorIn:self.view target:self].yOffset=-NAV_HEIGHT/2;
        }
    }];
}
- (void)fetchMoreSinglesList
{
    self.pageNum++;
    
    [[YGSessionService instance] fetchLockSinglesListPageNum:_pageNum SucessBlock:^(id data) {
        NSArray *arr = data;
        if (arr.count) {
            [self.singlesList addObjectsFromArray:data];
            [self.collectionView reloadData];
            [self.collectionView.mj_footer endRefreshing];
        } else {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [self endLoading];
    } errorBlock:^(NSError *error) {
        [self endLoading];
        self.pageNum--;
        if (self.singlesList.count) {
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:self.view].yOffset=-NAV_HEIGHT/2;
        }else{
            [YGHUD alertNetworkErrorIn:self.view target:self].yOffset=-NAV_HEIGHT/2;
        }
    }];
}

-(void)retryWhenNetworkError{
    [YGHUD loading:self.view];
    [self fetchSinglesList];
}

-(void)endLoading{
    [YGHUD hide:self.view];
    [self.collectionView reloadData];
    [self.collectionView.mj_header endRefreshing];
}

-(void)setupCollectionView{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.minimumLineSpacing = 8;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[YGSingleCell class] forCellWithReuseIdentifier:SINGLES_CELLID];
    [self.collectionView registerClass:[YGLockSingleCell class] forCellWithReuseIdentifier:LockSingleCell];
    [self.collectionView registerClass:[YGFirstInstallAlertCell class] forCellWithReuseIdentifier:FIRST_INSTALL_ALERT_CELLID];
    self.collectionView.mj_header = [YGRefreshHeader headerAtTarget:self action:@selector(fetchSinglesList) view: self.collectionView];
    
    MJRefreshAutoNormalFooter *foot = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(fetchMoreSinglesList)];
    [foot setRefreshingTitleHidden:YES];
//    [foot setTitle:@"  " forState:MJRefreshStatePulling];
    [foot setTitle:@"" forState:MJRefreshStateNoMoreData];
    self.collectionView.mj_footer = foot;
    
    self.collectionView.mj_footer.hidden = YES;
    [self.view addSubview:self.collectionView];
}

-(void)exitWithRemindAlert{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (status!=EKAuthorizationStatusAuthorized) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_USER_NOT_OPEN_REMIND_FOREVER"]==NO) {
            UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
            YGOpenReminderAlert *openReminder = [[YGOpenReminderAlert alloc] initWithFrame:CGRectMake(0,0,MIN(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT),MAX(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT))];
            openReminder.type = 1;
            [openReminder.openReminderBtn addTarget:self action:@selector(openReminder:) forControlEvents:UIControlEventTouchUpInside];
            [openReminder.notShowAgainBtn addTarget:self action:@selector(notAskMeReminder:) forControlEvents:UIControlEventTouchUpInside];
            [mainWindow addSubview:openReminder];
        }
    }
}
-(void)openReminder:(UIButton*)sender{
    YGOpenReminderAlert *openReminder = (YGOpenReminderAlert*)sender.superview.superview;
    [openReminder hide];
    YGSchedulingController *controller = [[YGSchedulingController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)notAskMeReminder:(UIButton*)sender{
    YGOpenReminderAlert *openReminder = (YGOpenReminderAlert*)sender.superview.superview;
    [openReminder hide];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"KEY_USER_NOT_OPEN_REMIND_FOREVER"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.hasAlertSinglesTip==NO) {
        return 2;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == [self numberOfSectionsInCollectionView:collectionView]-1) {
        return self.singlesList.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == [self numberOfSectionsInCollectionView:collectionView]-1) {
        
        YGSession *listModel = self.singlesList[indexPath.row];
        
        if (listModel.singlesLock.integerValue) {
            YGLockSingleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LockSingleCell forIndexPath:indexPath];
            cell.workout = listModel;
            return cell;
        } else {
            YGSingleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SINGLES_CELLID forIndexPath:indexPath];
            cell.workout = listModel;
            cell.delegate = self;
            return cell;
        }
    }
    YGFirstInstallAlertCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FIRST_INSTALL_ALERT_CELLID forIndexPath:indexPath];
    cell.text = @"Singles are one-off sessions\nwith specific themes";
    SEL action = @selector(didSelectCancelSinglesTip:);
    if ([cell.cancelAlertBtn respondsToSelector:action]==NO) {
        [cell.cancelAlertBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (section == [self numberOfSectionsInCollectionView:collectionView]-1) {
        insets = UIEdgeInsetsMake(16,16,36,16);
    }
    return insets;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat retW = collectionView.frame.size.width;
    CGFloat retH = 0;
    if (indexPath.section == [self numberOfSectionsInCollectionView:collectionView]-1) {
        retW = collectionView.frame.size.width-32;
        retH = retW*(140/343.0);
    }else{
        retH = retW*(58/375.0);
    }
    return CGSizeMake(retW,retH);
}

-(void)playWorkoutInSingle:(YGSession *)workout{
    if (workout.routineList.count) {
        YGPlayController *controller = [[YGPlayController alloc] init];
        controller.session = workout;
        controller.delegate = self;
        controller.challengeID = workout.singleChallengeID;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == [self numberOfSectionsInCollectionView:collectionView]-1) {
        YGSession *workout = self.singlesList[indexPath.row];
        YGSessionController *controller = [[YGSessionController alloc] init];
        controller.canPlay = workout.singlesLock.integerValue ? NO : YES;
        controller.isMustShare = workout.singlesLock.integerValue;
        controller.fromSingle = YES;
        controller.workoutID = workout.ID;
        controller.challengeID = workout.singleChallengeID;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        self.hasAlertSinglesTip = YES;
    }
}

-(void)didSelectCancelSinglesTip:(UIButton*)sender{
    self.hasAlertSinglesTip = YES;
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
