//
//  YGWorkoutController.m
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGUserInfoCell.h"
#import "YGChallenge.h"
#import "YGStringUtil.h"
#import "YGAppDelegate.h"
#import "YGUserService.h"
#import "YGUserNetworkService.h"
#import "YGNetworkService.h"
#import "YGRefreshHeader.h"
#import "YGShareInfoAlert.h"
#import "YGPlayController.h"
#import "YGChallengeService.h"
#import "YGWorkoutController.h"
#import "YGSessionController.h"
#import "YGChallenge+Extension.h"
#import "YGGuideLoginController.h"
#import "YGChallengeCompletedAlert.h"
#import "YGHomeSectionHeader.h"
#import "YGHomeCurrentChallengeCell.h"
#import "YGSessionService.h"
#import "YGSingleCell.h"
#import "YGPlayController.h"
#import "YGHomeAddSinglesFooter.h"
#import "YGDiscoverController.h"
#import "YGHomeNoSinglesCell.h"
#import "YGHomeCurrentChallengeCompleteCell.h"

static NSString *WORKOUT_USERINFO_CELLID  = @"userInfoCellID";
static NSString *WORKOUT_USER_SINGLES_CELLID   = @"userSinglesCellID";
static NSString *WORKOUT_CURRENT_CHALLENGE_CELLID  = @"currentChallengeCellID";
static NSString *WORKOUT_CURRENT_CHALLENGE_COMPLETE_CELLID  = @"currentChallengeCompleteCellID";
static NSString *WORKOUT_NO_SINGLES_CELLID  = @"noSinglesCellID";
static NSString *WORKOUT_SECTION_HEADERID  = @"homeSectionHeaderID";
static NSString *WORKOUT_ADD_SINGLES_FOOTERID  = @"addSinglesFooterID";

@interface YGWorkoutController ()<UICollectionViewDelegate,UICollectionViewDataSource,YGHomeCurrentChallengeCellDelegate,YGSingleCellDelegate,YGHomeCurrentChallengeCellCompleteDelegate>
@property (nonatomic,strong) YGChallenge *userChallenge;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *achievementList;
@property (nonatomic,strong) NSMutableArray *userSinglesList;
@property (nonatomic,strong) NSMutableArray *needShareInfoList;
@property (nonatomic,strong) NSMutableArray *completedChallengeIDList;
@property (nonatomic,assign) BOOL hasAlertSinglesTip;
@property (nonatomic,assign) BOOL hasAlertChallengesTip;
@end

@implementation YGWorkoutController{
    YGShareInfoAlert *shareInfoAlert;
    YGChallengeCompletedAlert *challengeCompletedAlert;
}

#pragma Life-Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    self.userSinglesList = [NSMutableArray array];
    self.achievementList = [NSMutableArray array];
    self.needShareInfoList = [NSMutableArray array];
    self.completedChallengeIDList = [NSMutableArray array];
    self.navigationItem.title =@"FITFLOW";
    [self setCollectionView];
    [YGHUD loading:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self beginFetch];
    [self.collectionView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.needShareInfoList removeAllObjects];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(generateNewShareInfo:) name:KEY_GENERATE_SHARE_INFO_WHEN_PLAYING object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KEY_GENERATE_SHARE_INFO_WHEN_PLAYING object:nil];
}

-(void)dealloc{
    [self removeNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)beginFetch{
    [self fetchUserInfo];
    [self fetchUserChallenge];
    [self fetchUserSinglesList];
}

-(void)fetchUserInfo{
    [[YGUserNetworkService instance] fetchUserAchievementSucessBlock:^(NSMutableArray* achievementList) {
        if (achievementList.count) {
            [self.achievementList removeAllObjects];
            [self.achievementList addObjectsFromArray:achievementList];
        }
        [self endLoading];
        
    } failureBlcok:^(NSError *error) {
        [self endLoading];
    }];
}

-(void)fetchUserChallenge{
    [[YGChallengeService instance] fetchUserCurrentChallengeSucessBlock:^(YGChallenge *challenge) {
        if (challenge) {
            self.userChallenge = challenge;
        }
        [self fetchUserChallengeEndLoading];
    } errorBlock:^(NSError *error) {
        [self endLoading];
        if (self.userChallenge==nil) {
            [YGHUD alertNetworkErrorIn:self.view target:self];
        }else{
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:self.view];
        }
    }];
}

-(void)fetchUserSinglesList{
    [[YGSessionService instance] fetchUserSinglesListSucessBlock:^(NSMutableArray *singlesList) {
        [self.userSinglesList removeAllObjects];
        if (singlesList.count) {
            [self.userSinglesList addObjectsFromArray:singlesList];
        }
        [self endLoading];
    } errorBlock:^(NSError *error) {
        [self endLoading];
        if (self.userChallenge==nil) {
            [YGHUD alertNetworkErrorIn:self.view target:self];
        }else{
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:self.view];
        }
    }];
}

-(void)retryWhenNetworkError{
    [YGHUD loading:self.view];
    [self beginFetch];
}

-(void)fetchUserChallengeEndLoading{
    [self endLoading];
    if (self.userChallenge.status.intValue>2) {
        BOOL findCompletedChallengeID = NO;
        for (NSString * completedChallengeID in self.completedChallengeIDList) {
            if ([self.userChallenge.ID isEqualToString:completedChallengeID]) {
                findCompletedChallengeID = YES;
                break;
            }
        }
        if (findCompletedChallengeID==NO) {
            [self alertIfChallengeCompleted];
            [self.needShareInfoList removeAllObjects];
            return;
        }
    }
    [self handleShareInfo];
}

-(void)endLoading{
    [YGHUD hide:self.view];
    [self.collectionView reloadData];
    [self.collectionView.mj_header endRefreshing];
}

-(void)alertIfChallengeCompleted{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if ([window.subviews.lastObject isKindOfClass:[YGChallengeCompletedAlert class]]==NO&&
        [window.subviews.lastObject isKindOfClass:[YGShareInfoAlert class]]==NO) {
        challengeCompletedAlert = [[YGChallengeCompletedAlert alloc] initWithFrame:window.bounds challengeTittle:self.userChallenge.title];
        [window addSubview:challengeCompletedAlert];
        [challengeCompletedAlert.shareBtn addTarget:self action:@selector(shareWhenChallengeCompleted) forControlEvents:UIControlEventTouchUpInside];
        [challengeCompletedAlert.startNewChallengeBtn addTarget:self action:@selector(startNewChallengeWhenChallengeCompleted) forControlEvents:UIControlEventTouchUpInside];
        if ([YGStringUtil notNull:self.userChallenge.ID]) {
            [self.completedChallengeIDList addObject:self.userChallenge.ID];
        }
    }
}

-(void)startNewChallengeWhenChallengeCompleted{
    [challengeCompletedAlert hide];
    YGUser *localUser = [[YGUserService instance] localUser];
    if (localUser.unRegistered==NO) {
        [self gotoDiscoverOptionIndex:0];
    }else{
        YGGuideLoginController *controller = [[YGGuideLoginController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.fromWorkourChangeNewChallenge = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)shareWhenChallengeCompleted{
    [challengeCompletedAlert hide];
    if (self.userChallenge.workoutList) {
        YGSession *workout = self.userChallenge.workoutList[0];
        if (workout.shareUrl) {
            NSString *shareTitle = [NSString stringWithFormat:@"I just finished this yoga challenge '%@' on the Fitflow app. I loved it. I think you will too. And it's free. %@",self.userChallenge.title,workout.shareUrl];
            [self shareWithContent:@[shareTitle]];
        }
    }
}

-(void)handleShareInfo{
    if (self.needShareInfoList.count>0) {
        UIWindow *mainWidow = [UIApplication sharedApplication].delegate.window;
        if ([mainWidow.subviews.lastObject isKindOfClass:[YGChallengeCompletedAlert class]]==NO&&
            [mainWidow.subviews.lastObject isKindOfClass:[YGShareInfoAlert class]]==NO) {
            shareInfoAlert = [[YGShareInfoAlert alloc] initWithFrame:mainWidow.bounds shareInfo:self.needShareInfoList];
            [mainWidow addSubview:shareInfoAlert];
            [shareInfoAlert.shareBtn addTarget:self action:@selector(shareWhenGenerateNewShareInfo) forControlEvents:UIControlEventTouchUpInside];
            [shareInfoAlert.cancelShareToFacebookBtn addTarget:self action:@selector(cancelShareToFacebookWhenGenerateNewShareInfo) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

-(void)generateNewShareInfo:(NSNotification*)notic{
    [self.needShareInfoList removeAllObjects];
    NSDictionary *shareInfo = notic.object;
    [self.needShareInfoList addObject:shareInfo];
}

-(void)shareWhenGenerateNewShareInfo{
    if (self.needShareInfoList.count) {
        NSDictionary *shareInfo = self.needShareInfoList[0];
        NSMutableArray *shareItems = [NSMutableArray array];
        NSString *shareUrl = [shareInfo objectForKey:@"shareUrl"];
        NSString *shareTitle = [shareInfo objectForKey:@"shareTitle"];
        if (shareTitle&&shareUrl) {
            [shareItems addObject:[NSString stringWithFormat:@"%@ %@",shareTitle,shareUrl]];
        }
        if (shareItems.count) {
            [self shareWithContent:shareItems];
        }
        [self.needShareInfoList removeAllObjects];
    }
    [shareInfoAlert hide];
}

-(void)cancelShareToFacebookWhenGenerateNewShareInfo{
    [shareInfoAlert hide];
}
#pragma mark UI
-(void)setCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 8;
    layout.sectionFootersPinToVisibleBounds = NO;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,GET_SCREEN_WIDTH, GET_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAV_HEIGHT) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0,0,48, 0);
    self.collectionView.mj_header = [YGRefreshHeader headerAtTarget:self action:@selector(beginFetch) view:self.collectionView];
    [self.collectionView registerClass:[YGUserInfoCell class] forCellWithReuseIdentifier:WORKOUT_USERINFO_CELLID];
    [self.collectionView registerClass:[YGSingleCell class] forCellWithReuseIdentifier:WORKOUT_USER_SINGLES_CELLID];
    [self.collectionView registerClass:[YGHomeNoSinglesCell class] forCellWithReuseIdentifier:WORKOUT_NO_SINGLES_CELLID];
    [self.collectionView registerClass:[YGHomeCurrentChallengeCell class] forCellWithReuseIdentifier:WORKOUT_CURRENT_CHALLENGE_CELLID];
    [self.collectionView registerClass:[YGHomeCurrentChallengeCompleteCell class] forCellWithReuseIdentifier:WORKOUT_CURRENT_CHALLENGE_COMPLETE_CELLID];
    [self.collectionView registerClass:[YGHomeSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WORKOUT_SECTION_HEADERID];
    [self.collectionView registerClass:[YGHomeAddSinglesFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:WORKOUT_ADD_SINGLES_FOOTERID];
    [self.view addSubview:self.collectionView];
}

#pragma UICollectionView-Datasouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return 1;
    }
    if (self.userSinglesList.count==0) {
        return 1;
    }
    return self.userSinglesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        YGUserInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WORKOUT_USERINFO_CELLID forIndexPath:indexPath];
        cell.achievementList = self.achievementList;
        return cell;
    }
    if (indexPath.section==1) {
        if (self.userChallenge.status.intValue>2) {
            YGHomeCurrentChallengeCompleteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WORKOUT_CURRENT_CHALLENGE_COMPLETE_CELLID forIndexPath:indexPath];
            cell.challenge = self.userChallenge;
            cell.delegate = self;
            return cell;
        }
        YGHomeCurrentChallengeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WORKOUT_CURRENT_CHALLENGE_CELLID forIndexPath:indexPath];
        cell.challenge = self.userChallenge;
        cell.delegate = self;
        return cell;
    }
    if (self.userSinglesList.count==0) {
        YGHomeNoSinglesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WORKOUT_NO_SINGLES_CELLID forIndexPath:indexPath];
        return cell;
    }
    YGSingleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WORKOUT_USER_SINGLES_CELLID forIndexPath:indexPath];
    cell.delegate = self;
    cell.workout = self.userSinglesList[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YGHomeSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:WORKOUT_SECTION_HEADERID forIndexPath:indexPath];
        header.alertTipLabel.hidden = YES;
        header.cancelAlertBtn.hidden = YES;
        YGAppDelegate *appDelegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
        if (indexPath.section==0) {
            header.textLabel.text = @"MY ACHIEVEMENTS";
        }else{
            SEL challengesTipAction = @selector(didSelectCloseChallengesHeaderTip:);
            SEL singlesTipAction = @selector(didSelectCloseSinglesHeaderTip:);
            if (indexPath.section==1){
                header.textLabel.text = @"MY CHALLENGE";
                if (appDelegate.fitflowUpdated&&self.hasAlertChallengesTip==NO) {
                    header.alertTipLabel.hidden = NO;
                    header.cancelAlertBtn.hidden = NO;
                    header.alertTipLabel.text = @"Challenges are 1-4 week programs\nthat help you achieve your goals";
                    [header.cancelAlertBtn removeTarget:self action:singlesTipAction forControlEvents:UIControlEventTouchUpInside];
                    if ([header.cancelAlertBtn respondsToSelector:challengesTipAction]==NO) {
                        [header.cancelAlertBtn addTarget:self action:challengesTipAction forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                
            }else{
                header.textLabel.text = @"MY SINGLES";
                if (appDelegate.fitflowUpdated&&self.hasAlertSinglesTip==NO) {
                    header.alertTipLabel.hidden = NO;
                    header.cancelAlertBtn.hidden = NO;
                    header.alertTipLabel.text = @"Singles are one-off sessions\nwith specific themes";
                    [header.cancelAlertBtn removeTarget:self action:challengesTipAction forControlEvents:UIControlEventTouchUpInside];
                    if ([header.cancelAlertBtn respondsToSelector:singlesTipAction]==NO) {
                        [header.cancelAlertBtn addTarget:self action:singlesTipAction forControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }
        }
        return header;
    }
    YGHomeAddSinglesFooter *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:WORKOUT_ADD_SINGLES_FOOTERID forIndexPath:indexPath];
    SEL action = @selector(didSelectAddMoreSingles:);
    if ([header.addSinglesBtn respondsToSelector:action]==NO) {
        [header.addSinglesBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return header;
}

#pragma mark UICollectionView-Layout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (section==2&&self.userSinglesList.count) {
        insets = UIEdgeInsetsMake(16,16,24,16);
    }
    return insets;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat retW = collectionView.frame.size.width;
    if (indexPath.section==0) {
        return CGSizeMake(retW,80*MAX(1,SCALE));
    }
    if (indexPath.section==1) {
        return CGSizeMake(retW,retW*(219/375.0));
    }
    if (self.userSinglesList.count==0) {
        return CGSizeMake(retW,retW*(52/375.0));
    }
    retW = retW-32;
    return CGSizeMake(retW,retW*(140/343.0));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGFloat retW = collectionView.frame.size.width;
    if (section==2) {
        return CGSizeMake(retW,(44/343.0)*(retW-32));
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat retW = collectionView.frame.size.width;
    CGFloat retH = ((32)/375.0)*retW;
    if (section==0) {
        return CGSizeMake(retW,((32)/375.0)*retW);
    }
    YGAppDelegate *appDelegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDelegate.fitflowUpdated) {
        if (section==1&&self.hasAlertChallengesTip==NO) {
            retH = retH+ ((58)/375.0)*retW;
        }
        if (section==2&&self.hasAlertSinglesTip==NO) {
            retH = retH+ ((58)/375.0)*retW;
        }
    }
    return CGSizeMake(retW,retH);
}
#pragma mark UICollectionView-Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section>0) {
        if (indexPath.section==1) {
            if (self.userChallenge.status.intValue>2) {
                return;
            }
            YGSession *workout = [self.userChallenge currentWorkout];
            if (workout.routineList.count) {
                YGSessionController *controller = [[YGSessionController alloc] init];
                controller.canPlay = YES;
                controller.workoutID = workout.ID;
                controller.hidesBottomBarWhenPushed = YES;
                controller.challengeID = self.userChallenge.ID;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else{
            YGSession *workout = self.userSinglesList[indexPath.row];
            YGSessionController *controller = [[YGSessionController alloc] init];
            controller.canPlay = YES;
            controller.fromSingle = YES;
            controller.workoutID = workout.ID;
            controller.hidesBottomBarWhenPushed = YES;
            controller.challengeID = workout.singleChallengeID;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark Do-Method
-(void)didSelectPlayCurrentWorkout:(YGSession *)workout{
    YGPlayController *controller = [[YGPlayController alloc] init];
    controller.session = workout;
    controller.hidesBottomBarWhenPushed = YES;
    controller.challengeID = self.userChallenge.ID;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)playWorkoutInSingle:(YGSession *)workout{
    YGPlayController *controller = [[YGPlayController alloc] init];
    controller.session = workout;
    controller.hidesBottomBarWhenPushed = YES;
    controller.challengeID = self.userChallenge.ID;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)didSelectAddMoreSingles:(UIButton*)sender{
    [self gotoDiscoverOptionIndex:1];
}

-(void)didSelectChooseNewChallangeInHomeCompleteChallengeCell{
    [self gotoDiscoverOptionIndex:0];
}

-(void)didSelectCloseChallengesHeaderTip:(UIButton*)sender{
    self.hasAlertChallengesTip = YES;
    [self.collectionView reloadData];
}

-(void)didSelectCloseSinglesHeaderTip:(UIButton*)sender{
    self.hasAlertSinglesTip = YES;
    [self.collectionView reloadData];
}

-(void)gotoDiscoverOptionIndex:(int)index{
    YGAppDelegate *appDelegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
    UITabBarController *tabBarController = (UITabBarController*)appDelegate.window.rootViewController;
    UINavigationController *discoverNav = tabBarController.viewControllers[1];
    [discoverNav popToRootViewControllerAnimated:NO];
    tabBarController.selectedIndex = 1;
    if (discoverNav.viewControllers.count) {
        YGDiscoverController *discoverController = (YGDiscoverController*)discoverNav.viewControllers[0];
        [discoverController setOptionIndex:index];
    }
}

@end
