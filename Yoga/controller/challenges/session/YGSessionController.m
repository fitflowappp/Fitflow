//
//  YGSessionController.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
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
#import "YGNeedRegisterAlert.h"
#import "YGSession+Extension.h"
#import "YGSessionBannerCell.h"
#import "YGSessionController.h"
#import "YGSessionLockedFooter.h"
#import "YGSessionUnlockedFooter.h"
#import "YGChallengeUnCompletedAlert.h"
#import "YGPlayController.h"
#import "YGNetworkService.h"
#import "YGUserNetworkService.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#define margin 16*SCALE

static NSString *ROUTINE_CELLID    = @"routineCellID";

static NSString *SESSION_HEADERID  = @"sessionHeaderID";

static NSString *SESSION_BANNER_CELLID   = @"sessionBannerCellID";

static NSString *SESSION_LOCKED_FOOTERID    = @"sessionLockedFooterID";

static NSString *SESSION_UNLOCKED_FOOTERID  = @"sessionUnlockedFooterID";

@interface YGSessionController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) YGSession *workout;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation YGSessionController{
    YGChallengeUnCompletedAlert *challengeUnCompletedAlert;
    YGNeedRegisterAlert *needRegisterAlert;
}

#pragma mark Life-Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItem];
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
    [[YGSessionService instance] fetchSessionWithChallengeID:self.challenge.ID sessionID:self.workoutID sucessBlock:^(YGSession *session) {
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
    [self.collectionView registerClass:[YGSessionLockedFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SESSION_LOCKED_FOOTERID];
    [self.collectionView registerClass:[YGSessionUnlockedFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SESSION_UNLOCKED_FOOTERID];
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
        cell.shouldLight = (self.shouldLight&&self.isMineChallenge);
        return cell;
    }
    YGRoutineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ROUTINE_CELLID forIndexPath:indexPath];
    cell.routineIndex = indexPath.row+1;
    cell.routine = self.workout.displayRoutineList[indexPath.row];
    if (indexPath.row==0) {
        if ([self collectionView:self.collectionView numberOfItemsInSection:1]==1) {
            cell.routineIndexType = ROUTINE_INDEX_ONLY_ONE;
        }else{
            cell.routineIndexType = ROUTINE_INDEX_TOP;
        }
    }else if(indexPath.row==[self collectionView:self.collectionView numberOfItemsInSection:1]-1){
        cell.routineIndexType = ROUTINE_INDEX_BOTTOM;
        
    }else{
        cell.routineIndexType = ROUTINE_INDEX_CENTER;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YGTextHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SESSION_HEADERID forIndexPath:indexPath];
        header.text = self.workout.attributedDescription;
        return header;
    }else{
        if (self.isMineChallenge&&self.shouldLight) {
            YGSessionUnlockedFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SESSION_UNLOCKED_FOOTERID forIndexPath:indexPath];
            SEL action = @selector(playVideo);
            if ([footer.playVedioBtn respondsToSelector:action]==NO) {
                [footer.playVedioBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
            }
            return footer;
        }else{
            YGSessionLockedFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SESSION_LOCKED_FOOTERID forIndexPath:indexPath];
            SEL action = @selector(startChallenge);
            if ([footer.startChallengeBtn respondsToSelector:action]==NO) {
                [footer.startChallengeBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
            }
            return footer;
        }
    }
}

#pragma mark UICollectionView-Layout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat scale = self.scale;
    return section==0?UIEdgeInsetsMake(8*scale,16*scale,16*scale,16*scale):UIEdgeInsetsMake(8*scale,16*scale,68*scale,16*scale);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat retW = collectionView.frame.size.width-margin*2;
    return CGSizeMake(retW,indexPath.section==0?retW*((float)386/686.0):retW*(128/686.0));
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
                style.tailIndent = -margin;
                style.headIndent = margin;
                style.firstLineHeadIndent = margin;
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setObject:[UIColor colorWithHexString:@"#4A4A4A"] forKey:NSForegroundColorAttributeName];
                [params setObject:[UIFont fontWithName:@"Lato-Regular" size:16*SCALE] forKey:NSFontAttributeName];
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
    
    return section==0?CGSizeZero:CGSizeMake(collectionView.frame.size.width,margin*2+(self.collectionView.frame.size.width-margin*2)*(96/686.0));
}

#pragma mark method

-(void)playVideo{
    YGUser *locolUser = [[YGUserService instance] localUser];
    if (locolUser.unRegistered==YES&&self.workoutIndex>1) {
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        needRegisterAlert = [[YGNeedRegisterAlert alloc] initWithFrame:mainWindow.bounds];
        [needRegisterAlert.facebookLoginBtn addTarget:self action:@selector(loginWithFaceBook) forControlEvents:UIControlEventTouchUpInside];
        [mainWindow addSubview:needRegisterAlert];
        return;
    }
    [self beginPlay];
    
}

-(void)beginPlay{
    if (self.workout.routineList.count) {
        YGPlayController *controller = [[YGPlayController alloc] init];
        controller.session = self.workout;
        controller.challenge = self.challenge;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)startChallenge{
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

-(void)loginWithFaceBook{
    [needRegisterAlert hide];
    __weak typeof(self) ws = self;
    [YGHUD loading:self.view];
    FBSDKLoginManager *mannger = [[FBSDKLoginManager alloc] init];
    [mannger logOut];
    [mannger logInWithReadPermissions:@[@"email",
                                        @"user_friends",
                                        @"public_profile"]
                   fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                       if (!error) {
                           if (result.isCancelled==YES) {
                               [YGHUD hide:ws.view];
                           }else{
                               
                               [[YGUserNetworkService instance] loginWithFacebookToken:result.token.tokenString sucessBlock:^(NSDictionary *result) {
                                   int code = [[result objectForKey:@"code"] intValue];
                                   if (code==1) {
                                       NSLog(@"msg: facebook logins sucess");
                                       [YGHUD hide:ws.view];
                                       [ws.navigationController popToRootViewControllerAnimated:YES];
                                   }else{
                                       [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
                                       
                                   }
                               } failureBlcok:^(NSError *error) {
                                   [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
                               }];
                           }
                           
                       }else{
                           [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
                       }
                   }];
    /**/
    NSString *requestUrl = [NSString stringWithFormat:@"%@/user/fblogin/wish",cRequestDomain];
    [[YGNetworkService instance] networkWithUrl:requestUrl requsetType:POST successBlock:^(id data) {
        NSLog(@"post yoga facebook login sucess");
    } errorBlock:^(NSError *error) {
        
    }];
    
}

@end
