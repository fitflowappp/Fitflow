//
//  YGWorkoutController.m
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGChallenge.h"
#import "YGStringUtil.h"
#import "YGTextHeader.h"
#import "YGWorkoutCell.h"
#import "YGAppDelegate.h"
#import "YGNetworkService.h"
#import "YGRefreshHeader.h"
#import "YGShareInfoAlert.h"
#import "YGPlayController.h"
#import "UIColor+Extension.h"
#import "YGChallengeService.h"
#import "YGWorkoutBannerCell.h"
#import "YGWorkoutController.h"
#import "YGSessionController.h"
#import "YGStartWorkoutFooter.h"
#import "YGChallenge+Extension.h"
#import "YGChallengeCompletedAlert.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#define margin 16*SCALE
static NSString *WORKOUT_BANNER_CELLID     = @"challengesCellID";

static NSString *WORKOUT_SESSION_CELLID    = @"currentChallengeCellID";

static NSString *WORKOUT_SESSION_HEADERID  = @"challengesHeaderID";

static NSString *WORKOUT_SESSION_FOOTERID  = @"challengesFooterID";

@interface YGWorkoutController ()<UICollectionViewDelegate,UICollectionViewDataSource,FBSDKSharingDelegate>
@property (nonatomic,strong) YGChallenge *userChallenge;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *needShareInfoList;
@property (nonatomic,strong) NSMutableArray *completedChallengeIDList;
@end

@implementation YGWorkoutController{
    YGShareInfoAlert *shareInfoAlert;
    YGChallengeCompletedAlert *challengeCompletedAlert;
}

#pragma Life-Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    self.needShareInfoList = [NSMutableArray array];
    self.completedChallengeIDList = [NSMutableArray array];
    self.navigationItem.title =@"My Next Workout";
    [self setCollectionView];
    [YGHUD loading:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchUserChallenge];
    [self.collectionView reloadData];
    [self handleShareInfo];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.needShareInfoList removeAllObjects];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(generateNewShareInfo:) name:KEY_GENERATE_NEW_SHARE_INFO object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KEY_GENERATE_NEW_SHARE_INFO object:nil];
}

-(void)dealloc{
    [self removeNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)fetchUserChallenge{
    __weak typeof(self) ws = self;
    [[YGChallengeService instance] fetchUserCurrentChallengeSucessBlock:^(YGChallenge *challenge) {
        if (challenge) {
            ws.userChallenge = challenge;
        }
        [ws endLoading];
    } errorBlock:^(NSError *error) {
        [ws endLoading];
        if (ws.userChallenge==nil) {
            [YGHUD alertNetworkErrorIn:ws.view target:ws];
        }else{
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
        }
    }];
}

-(void)retryWhenNetworkError{
    [YGHUD loading:self.view];
    [self fetchUserChallenge];
}

-(void)endLoading{
    [YGHUD hide:self.view];
    [self.collectionView reloadData];
    [self.collectionView.mj_header endRefreshing];
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
        }
    }
}

-(void)alertIfChallengeCompleted{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if ([window.subviews.lastObject isKindOfClass:[YGChallengeCompletedAlert class]]==NO&&
        [window.subviews.lastObject isKindOfClass:[YGShareInfoAlert class]]==NO) {
        challengeCompletedAlert = [[YGChallengeCompletedAlert alloc] initWithFrame:window.bounds challengeTittle:self.userChallenge.title];
        [window addSubview:challengeCompletedAlert];
        [challengeCompletedAlert.shareToFacebookBtn addTarget:self action:@selector(shareToFaceBookWhenChallengeCompleted) forControlEvents:UIControlEventTouchUpInside];
        [challengeCompletedAlert.startNewChallengeBtn addTarget:self action:@selector(startNewChallengeWhenChallengeCompleted) forControlEvents:UIControlEventTouchUpInside];
        if ([YGStringUtil notNull:self.userChallenge.ID]) {
            [self.completedChallengeIDList addObject:self.userChallenge.ID];
        }
    }
}

-(void)startNewChallengeWhenChallengeCompleted{
    [challengeCompletedAlert hide];
    YGAppDelegate *delegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
    UITabBarController *rootController = (UITabBarController*)delegate.window.rootViewController;
    rootController.selectedIndex = 1;
}

-(void)shareToFaceBookWhenChallengeCompleted{
    [challengeCompletedAlert hide];
    [self beginShareToFacebook];
}

-(void)handleShareInfo{
    if (self.needShareInfoList.count>0) {
        UIWindow *mainWidow = [UIApplication sharedApplication].delegate.window;
        if ([mainWidow.subviews.lastObject isKindOfClass:[YGChallengeCompletedAlert class]]==NO&&
            [mainWidow.subviews.lastObject isKindOfClass:[YGShareInfoAlert class]]==NO) {
            shareInfoAlert = [[YGShareInfoAlert alloc] initWithFrame:mainWidow.bounds shareInfo:self.needShareInfoList[0]];
            [mainWidow addSubview:shareInfoAlert];
            [shareInfoAlert.shareToFacebookBtn addTarget:self action:@selector(shareOnFaceBookWhenGenerateNewShareInfo) forControlEvents:UIControlEventTouchUpInside];
            [shareInfoAlert.cancelShareToFacebookBtn addTarget:self action:@selector(cancelShareToFacebookWhenGenerateNewShareInfo) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

-(void)generateNewShareInfo:(NSNotification*)notic{
    [self.needShareInfoList removeAllObjects];
    NSDictionary *shareInfo = notic.object;
    [self.needShareInfoList addObject:shareInfo];
}

-(void)cancelShareToFacebookWhenGenerateNewShareInfo{
    [shareInfoAlert hide];
    [self.needShareInfoList removeAllObjects];
}

-(void)shareOnFaceBookWhenGenerateNewShareInfo{
    [shareInfoAlert hide];
    [self beginShareToFacebook];
    [self.needShareInfoList removeAllObjects];
}

-(void)beginShareToFacebook{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"http://www.fitflow.io/ios/download"];
    FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2://"]]) {
        shareDialog.mode = FBSDKShareDialogModeNative;
    }else{
        shareDialog.mode = FBSDKShareDialogModeBrowser;
    }
    shareDialog.delegate = self;
    shareDialog.shareContent = content;
    shareDialog.fromViewController = self;
    [shareDialog show];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/yoga/share",cRequestDomain];
    [[YGNetworkService instance] networkWithUrl:requestUrl requsetType:PUT successBlock:^(id data) {
        NSLog(@"post yoga share sucess");
    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    
    
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    
    
}

#pragma mark UI
-(void)setCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.sectionFootersPinToVisibleBounds = YES;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,GET_SCREEN_WIDTH, GET_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAV_HEIGHT) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.mj_header = [YGRefreshHeader headerAtTarget:self action:@selector(fetchUserChallenge) view:self.collectionView];
    [self.collectionView registerClass:[YGWorkoutBannerCell class] forCellWithReuseIdentifier:WORKOUT_BANNER_CELLID];
    [self.collectionView registerClass:[YGWorkoutCell class] forCellWithReuseIdentifier:WORKOUT_SESSION_CELLID];
    [self.collectionView registerClass:[YGTextHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WORKOUT_SESSION_HEADERID];
    [self.collectionView registerClass:[YGStartWorkoutFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:WORKOUT_SESSION_FOOTERID];
    [self.view addSubview:self.collectionView];
}

#pragma UICollectionView-Datasouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section==0?1:self.userChallenge.workoutList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        YGWorkoutBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WORKOUT_BANNER_CELLID forIndexPath:indexPath];
        cell.challenge = self.userChallenge;
        return cell;
    }
    YGWorkoutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WORKOUT_SESSION_CELLID forIndexPath:indexPath];
    if (indexPath.row==0) {
        if ([self collectionView:self.collectionView numberOfItemsInSection:1]==1) {
            cell.workoutIndexType = WORKOUT_INDEX_ONLY_ONE;
        }else{
            cell.workoutIndexType = WORKOUT_INDEX_TOP;
        }
    }else if(indexPath.row==[self collectionView:self.collectionView numberOfItemsInSection:1]-1){
        cell.workoutIndexType = WORKOUT_INDEX_BOTTOM;
        
    }else{
        cell.workoutIndexType = WORKOUT_INDEX_CENTER;
    }
    cell.isMineChallengeWorkout = YES;
    cell.workoutIndex = indexPath.row+1;
    cell.workout = self.userChallenge.workoutList[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    /*START WORKOUT*/
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        YGStartWorkoutFooter *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:WORKOUT_SESSION_FOOTERID forIndexPath:indexPath];
        if ([header.startWorkoutBtn respondsToSelector:@selector(startWorkout)]==NO) {
            [header.startWorkoutBtn addTarget:self action:@selector(startWorkout) forControlEvents:UIControlEventTouchUpInside];
        }
        if (self.userChallenge.status.intValue>2) {
            [header.startWorkoutBtn setTitle:@"CHOOSE NEW CHALLENGE" forState:UIControlStateNormal];
        }else{
            [header.startWorkoutBtn setTitle:@"START WORKOUT" forState:UIControlStateNormal];
        }
        return header;
    }
    else{
        YGTextHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:WORKOUT_SESSION_HEADERID forIndexPath:indexPath];
        header.text = self.userChallenge.attributedDescription;
        return header;
    }
}

#pragma mark UICollectionView-Layout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat scale = self.scale;
    return section==0?UIEdgeInsetsMake(8*scale,16*scale,16*scale,16*scale):UIEdgeInsetsMake(8*scale,16*scale,68*scale,16*scale);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat retW = collectionView.frame.size.width-32*self.scale;
    return CGSizeMake(indexPath.section==0?retW:collectionView.frame.size.width,indexPath.section==0?retW*((float)280/686.0):retW*(128/686.0));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size = CGSizeZero;
    if (section==1&&self.userChallenge.workoutList.count) {
        size = CGSizeMake(collectionView.frame.size.width,margin*2+(self.collectionView.frame.size.width-margin*2)*(96/686.0));
    }
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeZero;
    if (section>0) {
        if (self.userChallenge.decriptionHeight.floatValue) {
            size = CGSizeMake(collectionView.frame.size.width,self.userChallenge.decriptionHeight.floatValue);
        }else{
            NSString *string = self.userChallenge.challengeDescription;
            if ([YGStringUtil notNull:string]) {
                NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:string];
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.tailIndent = -margin;
                style.headIndent = margin;
                style.firstLineHeadIndent = margin;
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setObject:[UIFont fontWithName:@"Lato-Regular" size:16*self.scale] forKey:NSFontAttributeName];
                [params setObject:[UIColor colorWithHexString:@"#4A4A4A"] forKey:NSForegroundColorAttributeName];
                [params setObject:style forKey:NSParagraphStyleAttributeName];
                [aString addAttributes:params range:NSMakeRange(0,string.length)];
                size = [YGStringUtil boundString:aString inSize:CGSizeMake(collectionView.frame.size.width,MAXFLOAT)];
                self.userChallenge.decriptionHeight = @(size.height);
                self.userChallenge.attributedDescription = aString;
            }
        }
    }
    return size;
}
#pragma mark UICollectionView-Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section>0) {
        YGSessionController *controller = [[YGSessionController alloc] init];
        YGSession *workout = self.userChallenge.workoutList[indexPath.row];
        controller.isMineChallenge = YES;
        controller.workoutIndex = indexPath.row;
        controller.workoutID = workout.ID;
        controller.hidesBottomBarWhenPushed = YES;
        controller.challenge = self.userChallenge;
        controller.shouldLight = workout.avail.boolValue;
        controller.navigationItem.title = workout.title;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark Do-Method
-(void)startWorkout{
    if (self.userChallenge.status.intValue>2) {
        YGAppDelegate *delegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
        UITabBarController *rootController = (UITabBarController*)delegate.window.rootViewController;
        rootController.selectedIndex = 1;
    }else{
        YGSession *currentWorkout = [self.userChallenge currentWorkout];
        if (currentWorkout) {
            YGSessionController *controller = [[YGSessionController alloc] init];
            controller.isMineChallenge = YES;
            controller.workoutID = currentWorkout.ID;
            controller.hidesBottomBarWhenPushed = YES;
            controller.challenge = self.userChallenge;
            controller.shouldLight  = currentWorkout.avail.boolValue;
            controller.navigationItem.title = currentWorkout.title;
            controller.workoutIndex = [self.userChallenge.workoutList indexOfObject:currentWorkout];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}
@end
