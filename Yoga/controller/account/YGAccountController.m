//
//  YGAccountController.m
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGUserService.h"
#import "YGNetworkService.h"
#import "UIColor+Extension.h"
#import "YGAboutUsController.h"
#import "YGAccountLoginFooter.h"
#import "YGAccountController.h"
#import "YGUserNetworkService.h"
#import "YGAccountEntranceCell.h"
#import "YGSchedulingController.h"
#import "YGAchievementController.h"
#import "YGFacebookLoginController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
static NSString *ACCOUNT_ENTRANCE_CELLID  = @"accountEntranceCellID";
static NSString *ACCOUNT_LOGIN_FOOTERID   = @"accountLoginFooterID";
@interface YGAccountController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UILabel     *userNameLabel;
@property (nonatomic,strong) UIImageView *userProfileImgv;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation YGAccountController

#pragma Life-Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollectionView];
    [self setUserMsgView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLocalUserInfo];
    [self.collectionView reloadData];
    self.navigationController.navigationBarHidden = YES;
}

-(void)setLocalUserInfo{
    YGUser *localUser = [[YGUserService instance] localUser];
    self.userNameLabel.text = localUser.name;
    if (localUser.profileData) {
        self.userProfileImgv.image = [UIImage imageWithData:localUser.profileData];
    }else{
        self.userProfileImgv.image = [UIImage imageNamed:@"user"];
    }
}
#pragma mark UI

-(void)setCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT-TAB_BAR_HEIGHT) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(295*self.scale,0,52*self.scale,0);
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[YGAccountEntranceCell class] forCellWithReuseIdentifier:ACCOUNT_ENTRANCE_CELLID];
    [self.collectionView registerClass:[YGAccountLoginFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ACCOUNT_LOGIN_FOOTERID];
    [self.view addSubview:self.collectionView];
}

-(void)setUserMsgView{
    /*头像*/
    self.userProfileImgv = [[UIImageView alloc] init];
    self.userProfileImgv.contentMode = UIViewContentModeScaleAspectFill;
    self.userProfileImgv.frame = CGRectMake((self.collectionView.frame.size.width-128*self.scale)/2,-self.collectionView.contentInset.top+97*self.scale,128*self.scale,128*self.scale);
    self.userProfileImgv.layer.masksToBounds = YES;
    self.userProfileImgv.layer.cornerRadius = self.userProfileImgv.frame.size.height/2;
    self.userProfileImgv.image = [UIImage imageNamed:@"user"];
    [self.collectionView addSubview:self.userProfileImgv];
    /*用户名称*/
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.frame = CGRectMake(0,CGRectGetMaxY(self.userProfileImgv.frame)+16*self.scale,self.collectionView.frame.size.width,22*self.scale);
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    self.userNameLabel.font = [UIFont fontWithName:@"Lato-Bold" size:18*self.scale];
    self.userNameLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    [self.collectionView addSubview:self.userNameLabel];
}

#pragma mark UICollectionView-Datasouce

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YGAccountEntranceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ACCOUNT_ENTRANCE_CELLID forIndexPath:indexPath];
    cell.entranceIndex = indexPath.row;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    YGAccountLoginFooter *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ACCOUNT_LOGIN_FOOTERID forIndexPath:indexPath];
    SEL action = @selector(loginWithFaceBook);
    if ([header.loginBtn respondsToSelector:action]==NO) {
        [header.loginBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return header;
}


#pragma mark UICollectionView-Layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.width-32*self.scale,64*self.scale);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,16*self.scale,24*self.scale,16*self.scale);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    YGUser *localUser = [[YGUserService instance] localUser];
    if (localUser.unRegistered==NO&&localUser.isLogin==YES) {
        return CGSizeZero;
    }
    return CGSizeMake(collectionView.frame.size.width,48*self.scale);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    /**/
    YGUser *localUser = [[YGUserService instance] localUser];
    if ((localUser.isLogin==NO||localUser.unRegistered==YES)) {
        YGFacebookLoginController *controller = [[YGFacebookLoginController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else{
        if (indexPath.row==0) {
            YGSchedulingController *controller = [[YGSchedulingController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row==1){
            YGAchievementController *controller = [[YGAchievementController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row==2){
            YGAboutUsController *controller = [[YGAboutUsController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

-(void)loginWithFaceBook{
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
                                   [YGHUD hide:ws.view];
                                   int code = [[result objectForKey:@"code"] intValue];
                                   if (code==1) {
                                       NSLog(@"msg: facebook logins sucess");
                                       [ws setLocalUserInfo];
                                       [ws.collectionView reloadData];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
