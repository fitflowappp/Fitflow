//
//  YGSessionController.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGTopAlert.h"
#import "YGRoutine.h"
#import "YGSession.h"
#import "YGAppDelegate.h"
#import "YGStringUtil.h"
#import "YGTextHeader.h"
#import "YGRoutineCell.h"
#import "YGRefreshHeader.h"
#import "YGSessionService.h"
#import "UIColor+Extension.h"
#import "YGUserService.h"
#import "YGSession+Extension.h"
#import "YGSessionBannerCell.h"
#import "YGSessionController.h"
#import "YGSessionLockedFooter.h"
#import "YGSessionUnlockedFooter.h"
#import "YGChallengeUnCompletedAlert.h"
#import "YGPlayController.h"
#import "YGNetworkService.h"
#import "YGUserNetworkService.h"
#import "YGChosenChallengeFooter.h"
#import "YGChallengeService.h"
#import "YGChangeChallengeAlert.h"
static NSString *ROUTINE_CELLID    = @"routineCellID";

static NSString *SESSION_HEADERID  = @"sessionHeaderID";

static NSString *SESSION_BANNER_CELLID   = @"sessionBannerCellID";

static NSString *SESSION_UNLOCKED_FOOTERID  = @"sessionUnlockedFooterID";

static NSString *CHALLENGE_CHOOSEN_FOOTERID  = @"challengeChooseFooterID";

@interface YGSessionController ()<UICollectionViewDelegate,UICollectionViewDataSource,YGSessionBannerCellDelegate>
@property (nonatomic,strong) YGSession *workout;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation YGSessionController{
    YGChallengeUnCompletedAlert *challengeUnCompletedAlert;
    __block YGChangeChallengeAlert *changeChallengeAlert;
    
}

#pragma mark Life-Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"CLASS";
    [self setLeftNavigationItem];
    [self setRightShareNavigationItem];
    [self setCollectionView];
    [YGHUD loading:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    self.navigationController.navigationBarHidden = NO;
    [self fetchWorkoutInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)fetchWorkoutInfo{
    __weak typeof(self) ws = self;
    [[YGSessionService instance] fetchSessionWithChallengeID:self.challengeID sessionID:self.workoutID sucessBlock:^(YGSession *session) {
        if (session) {
            ws.workout = session;
        }
        [ws endLoading];
    } errorBlock:^(NSError *error) {
        [ws endLoading];
        if (ws.workout) {
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
        }else{
            [YGHUD alertNetworkErrorIn:ws.view target:ws];
        }
    }];
}

-(void)retryWhenNetworkError{
    [YGHUD loading:self.view];
    [self fetchWorkoutInfo];
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
    [self.collectionView registerClass:[YGRoutineCell class] forCellWithReuseIdentifier:ROUTINE_CELLID];
    [self.collectionView registerClass:[YGSessionBannerCell class] forCellWithReuseIdentifier:SESSION_BANNER_CELLID];
    self.collectionView.mj_header = [YGRefreshHeader headerAtTarget:self action:@selector(fetchWorkoutInfo) view:self.collectionView];
    [self.collectionView registerClass:[YGTextHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SESSION_HEADERID];
    [self.collectionView registerClass:[YGSessionUnlockedFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SESSION_UNLOCKED_FOOTERID];
    [self.collectionView registerClass:[YGChosenChallengeFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CHALLENGE_CHOOSEN_FOOTERID];
    [self.view addSubview:self.collectionView];
}

#pragma mark UICollection-DataSouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.workout.displayRoutineList.count) {
        return 2;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section==0?1:self.workout.displayRoutineList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        YGSessionBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SESSION_BANNER_CELLID forIndexPath:indexPath];
        cell.session = self.workout;
        cell.shouldFavorate = self.fromSingle;
        cell.delegate = self;
        return cell;
    }
    YGRoutineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ROUTINE_CELLID forIndexPath:indexPath];
    cell.routine = self.workout.displayRoutineList[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YGTextHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SESSION_HEADERID forIndexPath:indexPath];
        header.text = self.workout.attributedDescription;
        return header;
    }else{
        if (self.canPlay||self.isMineChallenge) {
            YGSessionUnlockedFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SESSION_UNLOCKED_FOOTERID forIndexPath:indexPath];
            SEL action = @selector(playVideo);
            if ([footer.playVedioBtn respondsToSelector:action]==NO) {
                [footer.playVedioBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
            }
            return footer;
        }else{
            YGChosenChallengeFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CHALLENGE_CHOOSEN_FOOTERID forIndexPath:indexPath];
            SEL action = @selector(showChangeChallengeAletIfNotFromUserChallenge);
            if ([footer.choosenChallengeBtn respondsToSelector:action]==NO) {
                [footer.choosenChallengeBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
            }
            return footer;
        }
    }
}

#pragma mark UICollectionView-Layout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return section==0?UIEdgeInsetsMake(16,16,16,16):UIEdgeInsetsMake(16,16,50,16);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat retW = collectionView.frame.size.width-32;
    return CGSizeMake(retW,indexPath.section==0?retW*(140/343.0):retW*(72/343.0));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeZero;
    if (section>0) {
        if (self.workout.decriptionHeight.floatValue) {
            size = CGSizeMake(collectionView.frame.size.width,self.workout.decriptionHeight.floatValue);
        }else{
            NSString *string = self.workout.sessionDescription;
            if ([YGStringUtil notNull:string]) {
                NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:string];
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.tailIndent = -32;
                style.headIndent = 32;
                style.minimumLineHeight = 22;
                style.firstLineHeadIndent = 32;
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setObject:[UIColor colorWithHexString:@"#A4A3A3"] forKey:NSForegroundColorAttributeName];
                [params setObject:[UIFont fontWithName:@"Lato-Regular" size:14] forKey:NSFontAttributeName];
                [params setObject:style forKey:NSParagraphStyleAttributeName];
                [aString addAttributes:params range:NSMakeRange(0,string.length)];
                size = [YGStringUtil boundString:aString inSize:CGSizeMake(collectionView.frame.size.width,MAXFLOAT)];
                self.workout.decriptionHeight = @(size.height);
                self.workout.attributedDescription = aString;
            }
        }
    }
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return section==0?CGSizeZero:CGSizeMake(collectionView.frame.size.width,32+(self.collectionView.frame.size.width-32)*(44/343.0));
}

#pragma mark method
-(void)playVideo{
    if (self.isMineChallenge==YES&&self.canPlay==NO) {
        [self showWorkoutLockedAlertIfFromUserChallenge];
        return;
    }
    if (self.workout.routineList.count) {
        YGPlayController *controller = [[YGPlayController alloc] init];
        controller.session = self.workout;
        controller.challengeID = self.challengeID;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)handleFavorate:(BOOL)favorate{
    NSString *requestURL = nil;
    if (favorate==YES) {
        requestURL = [NSString stringWithFormat:@"%@%@/%@",cRequestDomain,@"/yoga/challenge/myworkout/add",self.workout.ID];
    }else{
        requestURL = [NSString stringWithFormat:@"%@%@/%@/delete",cRequestDomain,@"/yoga/challenge/myworkout",self.workout.ID];
    }
    [YGHUD loading:self.view];
    [[YGNetworkService instance] networkWithUrl:requestURL requsetType:favorate?PUT:DELETE successBlock:^(id data) {
        [YGHUD hide:self.view];
        NSDictionary *result = [data objectForKey:@"result"];
        if ([[result objectForKey:@"code"] intValue]==1) {
            self.workout.favorate = @(favorate);
            [self.collectionView reloadData];
            if (favorate==YES) {
                NSString *msg = [result objectForKey:@"msg"];
                [YGTopAlert alert:msg bkColorCode:@"#41D395"];
            }
        }else{
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:self.view];
        }
    } errorBlock:^(NSError *error) {
        [YGHUD hide:self.view];
        [YGHUD alertMsg:NETWORK_ERROR_ALERT at:self.view];
    }];
}

#pragma mark
-(void)showWorkoutLockedAlertIfFromUserChallenge{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if ([window.subviews.lastObject isKindOfClass:[YGChallengeUnCompletedAlert class]]==NO) {
        challengeUnCompletedAlert = [[YGChallengeUnCompletedAlert alloc] initWithFrame:window.bounds];
        [window addSubview:challengeUnCompletedAlert];
        SEL action = @selector(backIfFromUserChallenge:);
        if ([challengeUnCompletedAlert.backToCurrentWorkoutBtn respondsToSelector:action]==NO) {
            [challengeUnCompletedAlert.backToCurrentWorkoutBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

-(void)backIfFromUserChallenge:(UIButton*)sender{
    [challengeUnCompletedAlert hide];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark

-(void)showChangeChallengeAletIfNotFromUserChallenge{
    if (self.userCurrentChallenge.status.intValue>2) {
        [self changeChallengeNetwork];
    }else{
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        NSString *alertMsg = [NSString stringWithFormat:@"Are you sure you want to change from %@ to %@?",self.userCurrentChallenge.title,self.fromChallenge.title];
        changeChallengeAlert = [[YGChangeChallengeAlert alloc] initWithFrame:mainWindow.bounds contentTittle:alertMsg];
        SEL action = @selector(changeChallengeNetwork);
        if ([changeChallengeAlert.changeBtn respondsToSelector:action]==NO) {
            [changeChallengeAlert.changeBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        }
        [mainWindow addSubview:changeChallengeAlert];
    }
}

-(void)didSelectChangeChallengeBtn:(UIButton*)sender{
    [changeChallengeAlert hide];
    [self changeChallengeNetwork];
}

-(void)changeChallengeNetwork{
    //更换挑战
    __block  UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [YGHUD loading:window];
    [[YGChallengeService instance] changeChallengeWithChallengID:self.fromChallenge.ID sucessBlock:^(YGChallenge* challenge) {
        [YGHUD hide:window];
        [changeChallengeAlert hide];
        YGAppDelegate *delegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate backToWorkout];
    } errorBlock:^(NSError *error) {
        [YGHUD alertMsg:NETWORK_ERROR_ALERT at:window].yOffset=0;
    }];
}
#pragma share
-(void)didSelectShareItem{
    if (self.workout.shareUrl) {
        NSString *shareTitle = [NSString stringWithFormat:@"I found this interesting yoga class on the Fitflow app. It's called %@. Want to try it with me? It's free. %@",self.workout.title,self.workout.shareUrl];
        [self shareWithContent:@[shareTitle]];
    }
}
@end
