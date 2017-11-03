//
//  YGChallengeController.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGUserService.h"
#import "YGAppDelegate.h"
#import "YGStringUtil.h"
#import "YGTextHeader.h"
#import "YGWorkoutCell.h"
#import "YGNetworkService.h"
#import "YGPlayController.h"
#import "YGRefreshHeader.h"
#import "YGChallengeService.h"
#import "UIColor+Extension.h"
#import "YGSessionController.h"
#import "YGStartWorkoutFooter.h"
#import "YGChallengeBannerCell.h"
#import "YGChallengeController.h"
#import "YGChallenge+Extension.h"
#import "YGUnlockChallengeFooter.h"
#import "YGChosenChallengeFooter.h"
#import "YGChangeChallengeAlert.h"
#import "YGChallengeUnCompletedAlert.h"
#define margin 16*SCALE
static NSString *CHALLENGE_BANNER_CELLID     = @"challengesCellID";

static NSString *CHALLENGE_SESSION_CELLID    = @"currentChallengeCellID";

static NSString *CHALLENGE_SESSION_HEADERID  = @"challengesHeaderID";

static NSString *CHALLENGE_CHOOSEN_FOOTERID  = @"challengeChooseFooterID";

static NSString *CHALLENGE_UNLOCKED_FOOTERID = @"challengeUnlockedFooterID";

static NSString *START_WORKOUT_FOOTERID      = @"startWorkoutFooterID";

@interface YGChallengeController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) YGChallenge *challenge;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation YGChallengeController{
    __block YGChangeChallengeAlert *changeChallengeAlert;
    YGChallengeUnCompletedAlert *challengeUnCompletedAlert;
    
}
#pragma mark Life-Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Challenge";
    [self setCollectionView];
    [self setLeftNavigationItem];
    [YGHUD loading:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchChallengeInfo];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)fetchChallengeInfo{
    __weak typeof(self) ws = self;
    [[YGChallengeService instance] fetchChallengeWithChallengeId:self.challengeID sucessBlock:^(YGChallenge *challenge) {
        if (challenge) {
            ws.challenge = challenge;
        }
        [ws endLoading];
    } errorBlock:^(NSError *error) {
        [ws endLoading];
        if (ws.challenge) {
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
        }else{
            [YGHUD alertNetworkErrorIn:ws.view target:ws];
        }
        
    }];
}

-(void)retryWhenNetworkError{
    [YGHUD loading:self.view];
    [self fetchChallengeInfo];
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
    [self.collectionView registerClass:[YGChallengeBannerCell class] forCellWithReuseIdentifier:CHALLENGE_BANNER_CELLID];
    [self.collectionView registerClass:[YGWorkoutCell class] forCellWithReuseIdentifier:CHALLENGE_SESSION_CELLID];
    self.collectionView.mj_header = [YGRefreshHeader headerAtTarget:self action:@selector(fetchChallengeInfo) view:self.collectionView];
    [self.collectionView registerClass:[YGTextHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CHALLENGE_SESSION_HEADERID];
    
    [self.collectionView registerClass:[YGChosenChallengeFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CHALLENGE_CHOOSEN_FOOTERID];
    [self.collectionView registerClass:[YGUnlockChallengeFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CHALLENGE_UNLOCKED_FOOTERID];
    [self.collectionView registerClass:[YGStartWorkoutFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:START_WORKOUT_FOOTERID];
    [self.view addSubview:self.collectionView];
}

#pragma mark UICollection-DataSouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.challenge) {
        return 2;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return section==0?1:self.challenge.workoutList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        YGChallengeBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CHALLENGE_BANNER_CELLID forIndexPath:indexPath];
        cell.challenge = self.challenge;
        cell.shouldLight = (self.shouldLigth||self.isMineChallenge);
        return cell;
    }
    YGWorkoutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CHALLENGE_SESSION_CELLID forIndexPath:indexPath];
    cell.workoutIndex = indexPath.row+1;
    cell.isMineChallengeWorkout = self.isMineChallenge;
    cell.workout = self.challenge.workoutList[indexPath.row];
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
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YGTextHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CHALLENGE_SESSION_HEADERID forIndexPath:indexPath];
        header.text = self.challenge.attributedDescription;
        return header;
    }else{
        /*user current challenge footer*/
        if (self.isMineChallenge==YES) {
            YGStartWorkoutFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:START_WORKOUT_FOOTERID forIndexPath:indexPath];
            if ([footer.startWorkoutBtn respondsToSelector:@selector(startWorkout)]==NO) {
                [footer.startWorkoutBtn addTarget:self action:@selector(startWorkout) forControlEvents:UIControlEventTouchUpInside];
            }
            return footer;
        }
        /*unlocked*/
        if (self.shouldLigth==YES) {
            YGChosenChallengeFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CHALLENGE_CHOOSEN_FOOTERID forIndexPath:indexPath];
            SEL action = @selector(chooseThisChallenge);
            if ([footer.choosenChallengeBtn respondsToSelector:action]==NO) {
                [footer.choosenChallengeBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
            }
            return footer;
        }
        /*locked*/
        YGUnlockChallengeFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CHALLENGE_UNLOCKED_FOOTERID forIndexPath:indexPath];
        SEL action = @selector(unlockThisChallenge);
        if ([footer.unlockChallengeBtn respondsToSelector:action]==NO) {
            [footer.unlockChallengeBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        }
        return footer;
    }
}

#pragma mark UICollectionView-Layout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat scale = self.scale;
    return section==0?UIEdgeInsetsMake(8*scale,16*scale,16*scale,16*scale):UIEdgeInsetsMake(8*scale,16*scale,68*scale,16*scale);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat retW = collectionView.frame.size.width-32*self.scale;
    return CGSizeMake(indexPath.section==0?retW:collectionView.frame.size.width,indexPath.section==0?retW*((float)386/686.0):retW*(128/686.0));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size = CGSizeZero;
    if (section==1) {
        size = CGSizeMake(collectionView.frame.size.width,margin*2+(self.collectionView.frame.size.width-margin*2)*(96/686.0));
    }
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size = CGSizeZero;
    if (section>0) {
        if (self.challenge.decriptionHeight.floatValue) {
            size = CGSizeMake(collectionView.frame.size.width,self.challenge.decriptionHeight.floatValue);
        }else{
            NSString *string = self.challenge.challengeDescription;
            if ([YGStringUtil notNull:string]) {
                NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:string];
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.tailIndent = -16;
                style.headIndent = 16;
                style.firstLineHeadIndent = 16;
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setObject:[UIColor colorWithHexString:@"#4A4A4A"] forKey:NSForegroundColorAttributeName];
                [params setObject:[UIFont fontWithName:@"Lato-Regular" size:16*self.scale] forKey:NSFontAttributeName];
                [params setObject:style forKey:NSParagraphStyleAttributeName];
                [aString addAttributes:params range:NSMakeRange(0,string.length)];
                size = [YGStringUtil boundString:aString inSize:CGSizeMake(collectionView.frame.size.width,MAXFLOAT)];
                self.challenge.decriptionHeight = @(size.height);
                self.challenge.attributedDescription = aString;
            }
        }
    }
    return size;
}
#pragma mark UICollectionView-Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section>0) {
        YGSessionController *controller = [[YGSessionController alloc] init];
        YGSession *workout = self.challenge.workoutList[indexPath.row];
        controller.workoutID = workout.ID;
        controller.challenge = self.challenge;
        controller.workoutIndex = indexPath.row;
        controller.shouldLight = workout.avail.boolValue;
        controller.isMineChallenge = self.isMineChallenge;
        controller.navigationItem.title = workout.title;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
#pragma mark method

-(void)startWorkout{
    YGSession *currentWorkout = [self.challenge currentWorkout];
    if (currentWorkout) {
        YGSessionController *controller = [[YGSessionController alloc] init];
        controller.isMineChallenge = YES;
        controller.challenge = self.challenge;
        controller.workoutID = currentWorkout.ID;
        controller.hidesBottomBarWhenPushed = YES;
        controller.shouldLight = currentWorkout.avail.boolValue;
        controller.navigationItem.title = currentWorkout.title;
        controller.workoutIndex = [self.challenge.workoutList indexOfObject:currentWorkout];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)unlockThisChallenge{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if ([window.subviews.lastObject isKindOfClass:[YGChallengeUnCompletedAlert class]]==NO) {
        challengeUnCompletedAlert = [[YGChallengeUnCompletedAlert alloc] initWithFrame:window.bounds];
        [window addSubview:challengeUnCompletedAlert];
        SEL backToCurrentWorkoutAction = @selector(backToCurrentWorkout:);
        if ([challengeUnCompletedAlert.backToCurrentWorkoutBtn respondsToSelector:backToCurrentWorkoutAction]==NO) {
            [challengeUnCompletedAlert.backToCurrentWorkoutBtn addTarget:self action:backToCurrentWorkoutAction forControlEvents:UIControlEventTouchUpInside];
        }
    }
}
-(void)backToCurrentWorkout:(UIButton*)sender{
    [challengeUnCompletedAlert hide];
    YGAppDelegate *delegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate backToWorkout];
}

-(void)chooseThisChallenge{
    if (self.currentChallenge.status.intValue>2) {
        [self changeChallengeNetwork];
    }else{
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        NSString *alertMsg = [NSString stringWithFormat:@"Are you sure you want to change from %@ to %@?",self.currentChallenge.title,self.challenge.title];
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
    [[YGChallengeService instance] changeChallengeWithChallengID:self.challenge.ID sucessBlock:^(YGChallenge* challenge) {
        [YGHUD hide:window];
        [changeChallengeAlert hide];
        YGAppDelegate *delegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate backToWorkout];
    } errorBlock:^(NSError *error) {
        [YGHUD alertMsg:NETWORK_ERROR_ALERT at:window].yOffset=0;
    }];
}

@end
