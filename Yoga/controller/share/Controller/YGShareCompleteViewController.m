//
//  YGShareCompleteViewController.m
//  Yoga
//
//  Created by 何侨 on 2018/1/29.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGShareCompleteViewController.h"
#import "YGHUD.h"
#import "UIColor+Extension.h"
#import "YGSingleCell.h"
#import "YGRefreshHeader.h"
#import "YGSessionService.h"
#import "YGPlayController.h"
#import "YGSessionController.h"
#import "YGFirstInstallAlertCell.h"
#import "YGLockSingleCell.h"
#import "YGDeviceUtil.h"
#import "YGTopAlert.h"

static NSString *SINGLES_CELLID = @"singlesCellID";
static NSString *FIRST_INSTALL_ALERT_CELLID = @"firstInstallALertCellID";
static NSString *LockSingleCell = @"YGLockSingleCell";

@interface YGShareCompleteViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,YGSingleCellDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray   *singlesList;
@property (nonatomic, strong) UILabel *noContentLabel;
@property (nonatomic,assign) BOOL hasAlertSinglesTip;

@end

@implementation YGShareCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"BONUS SINGLES";
    self.singlesList = [NSMutableArray array];
    self.hasAlertSinglesTip = [YGDeviceUtil hasEnteredSinglesInDiscover];
    self.view.frame = CGRectMake(GET_SCREEN_WIDTH,0,GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT-NAV_HEIGHT);
    [self setupCollectionView];
    [self setLeftNavigationItem];
    [YGHUD loading:self.view];
    [YGTopAlert alert:@"Thanks for sharing! Pick a bonus class as a reward." bkColorCode:@"#41D395"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchSinglesList];
    [self.collectionView reloadData];
}

-(void)fetchSinglesList{
    [[YGSessionService instance] fetchUnlockSinglesListSucessBlock:^(id data) {
        if (data) {
            [self.singlesList removeAllObjects];
            [self.singlesList addObjectsFromArray:data];
            [self.collectionView reloadData];
        }
        if (!self.singlesList.count) {
            [self.collectionView removeFromSuperview];
            [self.view addSubview:self.noContentLabel];
        }
        [self endLoading];
    } errorBlock:^(NSError *error) {
        [self endLoading];
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
    [self.view addSubview:self.collectionView];
}

- (UILabel *)noContentLabel
{
    if (!_noContentLabel) {
        _noContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*SCALE, 20, GET_SCREEN_WIDTH - 40*SCALE, 100)];
        _noContentLabel.text = @"You have already unlocken all of the bonus Singles avaliable. Thank you for being such an active Fitflow user. \n\n Keep coming back to check regularly for more free bonus Singles to unlock.";
        _noContentLabel.textColor = [UIColor colorWithHexString:@"C5C5C5"];
        _noContentLabel.numberOfLines = 0;
        _noContentLabel.textAlignment = NSTextAlignmentCenter;
        _noContentLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    }
    return _noContentLabel;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return self.singlesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        YGLockSingleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LockSingleCell forIndexPath:indexPath];
        cell.workout = self.singlesList[indexPath.row];
        return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets = UIEdgeInsetsMake(16,16,16,16);
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
        controller.challengeID = workout.singleChallengeID;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == [self numberOfSectionsInCollectionView:collectionView]-1) {
        YGSession *workout = self.singlesList[indexPath.row];
        YGSessionController *controller = [[YGSessionController alloc] init];
        controller.canPlay = NO;
        controller.isShareComplete = YES;
        controller.fromSingle = YES;
        controller.workoutID = workout.ID;
        controller.challengeID = workout.singleChallengeID;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        self.hasAlertSinglesTip = YES;
    }
}

//-(void)didSelectCancelSinglesTip:(UIButton*)sender{
//    self.hasAlertSinglesTip = YES;
//    [self.collectionView reloadData];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
