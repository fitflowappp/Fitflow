//
//  YGBeginMyWorkoutController.m
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGUserService.h"
#import "YGLoginController.h"
#import "YGSignUpController.h"
#import "YGUserNetworkService.h"
#import "YGBeginMyWorkoutPlayer.h"
#import "YGBeginMyWorkoutController.h"
@interface YGBeginMyWorkoutController ()<YGBeginMyWorkoutPlayerDelegate>
@property (nonatomic,strong) YGBeginMyWorkoutPlayer *beginMyWorkoutPlayer;
@end

@implementation YGBeginMyWorkoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self anonymousLogin];
    [self addPlayer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)anonymousLogin{
    /*匿名登录*/
    if ([YGUserService instance].localUser.isLogin==NO) {
        [[YGUserNetworkService instance] anonymousLoginSucessBlock:^(NSDictionary *result) {
            
        } failureBlcok:^(NSError *error) {
            
        }];
    }
}

-(void)addPlayer{
    self.beginMyWorkoutPlayer = [[YGBeginMyWorkoutPlayer alloc] init];
    self.beginMyWorkoutPlayer.delegate = self;
    [self.view addSubview:self.beginMyWorkoutPlayer];
}

-(void)login{
    YGLoginController *controller = [[YGLoginController alloc] init];
    controller.fromBeginWorkout = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)beginMyWorkout{
    
    __weak typeof(self) ws = self;
    if ([YGUserService instance].localUser.isLogin==NO) {
        [YGHUD loading:ws.view];
        [[YGUserNetworkService instance] anonymousLoginSucessBlock:^(NSDictionary *result) {
            [YGHUD hide:self.view];
            int code = [[result objectForKey:@"code"] intValue];
            if (code==1) {
                YGSignUpController *controller = [[YGSignUpController alloc] init];
                controller.fromBeginWorkout = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
            }
        } failureBlcok:^(NSError *error) {
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
        }];
    }else{
        YGSignUpController *controller = [[YGSignUpController alloc] init];
        controller.fromBeginWorkout = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
