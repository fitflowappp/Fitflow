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
#import "YGPlayController.h"
#import <FirebaseDatabase/FirebaseDatabase.h>
#import "YGOpenReminderAlert.h"
#import "YGSchedulingController.h"
#import <EventKit/EventKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
static NSString *CHALLENGE_BANNER_CELLID     = @"challengesCellID";

static NSString *CHALLENGE_SESSION_CELLID    = @"currentChallengeCellID";

static NSString *CHALLENGE_SESSION_HEADERID  = @"challengesHeaderID";

static NSString *CHALLENGE_CHOOSEN_FOOTERID  = @"challengeChooseFooterID";

static NSString *START_WORKOUT_FOOTERID      = @"startWorkoutFooterID";

@interface YGChallengeController ()<UICollectionViewDelegate,UICollectionViewDataSource,YGPlayBaseControllerDelegate>
@property (nonatomic,strong) YGChallenge *challenge;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation YGChallengeController{
    __block YGChangeChallengeAlert *changeChallengeAlert;
    
}
#pragma mark Life-Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"CHALLENGE";
    [self setCollectionView];
    [self setLeftNavigationItem];
    [self setRightShareNavigationItem];
    [YGHUD loading:self.view];
    
    [FBSDKAppEvents logEvent:FBEVENTUPDATEKEY_CHALLENGEDETAIL(_challengeID)];
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
    [self.collectionView registerClass:[YGStartWorkoutFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:START_WORKOUT_FOOTERID];
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
        if (self.isMineChallenge==YES) {
            YGStartWorkoutFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:START_WORKOUT_FOOTERID forIndexPath:indexPath];
            if ([footer.startWorkoutBtn respondsToSelector:@selector(startWorkout)]==NO) {
                [footer.startWorkoutBtn addTarget:self action:@selector(startWorkout) forControlEvents:UIControlEventTouchUpInside];
            }
            return footer;
        }
        YGChosenChallengeFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CHALLENGE_CHOOSEN_FOOTERID forIndexPath:indexPath];
        SEL action = @selector(chooseThisChallenge);
        if ([footer.choosenChallengeBtn respondsToSelector:action]==NO) {
            [footer.choosenChallengeBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        }
        return footer;
    }
}

#pragma mark UICollectionView-Layout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat scale = self.scale;
    return section==0?UIEdgeInsetsMake(0,0,16,0):UIEdgeInsetsMake(8*scale,16*scale,68*scale,16*scale);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat retW = collectionView.frame.size.width;
    if (indexPath.section==0) {
        return CGSizeMake(retW,retW*(153.0/375));
    }
    return CGSizeMake(retW,(retW-32)*(128/686.0));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size = CGSizeZero;
    if (section==1) {
        size = CGSizeMake(collectionView.frame.size.width,32+(self.collectionView.frame.size.width-32)*(44/343.0));
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
        controller.challengeID = self.challenge.ID;
        controller.isMineChallenge = self.isMineChallenge;
        controller.canPlay = self.isMineChallenge&&workout.avail.boolValue;
        controller.fromChallenge = self.challenge;
        controller.userCurrentChallenge = self.userCurrentChallenge;
        controller.navigationItem.title = workout.title;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
#pragma mark method

-(void)startWorkout{
    YGSession *currentWorkout = [self.challenge currentWorkout];
    if (currentWorkout) {
        YGPlayController *controller = [[YGPlayController alloc] init];
        controller.session = currentWorkout;
        controller.challengeID = self.challenge.ID;
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)chooseThisChallenge{
    if (self.userCurrentChallenge.status.intValue>2) {
        [self changeChallengeNetwork];
    }else{
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        NSString *alertMsg = nil;
        if (self.userCurrentChallenge) {
            alertMsg = [NSString stringWithFormat:@"Are you sure you want to change from %@ to %@?",self.userCurrentChallenge.title,self.challenge.title];
        } else {
            alertMsg = [NSString stringWithFormat:@"Are you sure you want to change to %@?", self.challenge.title];
        }
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
        [FBSDKAppEvents logEvent:FBEVENTUPDATEKEY_CHALLENGE(self.challenge.ID)];
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
    if (self.challenge.workoutList.count) {
        YGSession *workout = self.challenge.workoutList[0];
        if (workout.shareUrl) {
            NSString *shareTitle = [NSString stringWithFormat:@"I found this interesting yoga challenge on the Fitflow app. It's called %@. Want to try it with me? It's free. %@",self.challenge.title,workout.shareUrl];
            [self shareWithContent:@[shareTitle]];
        }
    }
}
@end
