//
//  YGBeginMyWorkoutController.m
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGAppDelegate.h"
#import "YGUserService.h"
#import "YGUserNetworkService.h"
#import "YGBeginMyWorkoutPlayer.h"
#import "YGBeginMyWorkoutController.h"
#import "YGDefaultSessionController.h"
#import "YGFacebookLoginController.h"
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
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"player" ofType:@"mp4"];
//    self.beginMyWorkoutPlayer = [[YGBeginMyWorkoutPlayer alloc] initWithUrl:[NSURL fileURLWithPath:path]];
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"player" ofType:@"mp4"];
    self.beginMyWorkoutPlayer = [[YGBeginMyWorkoutPlayer alloc] init];
    self.beginMyWorkoutPlayer.delegate = self;
    [self.view addSubview:self.beginMyWorkoutPlayer];
    //[self.beginMyWorkoutPlayer play];
}

-(void)login{
    YGFacebookLoginController *controller = [[YGFacebookLoginController alloc] init];
    controller.fromBeginMyWorkout = YES;
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
                YGDefaultSessionController *controller = [[YGDefaultSessionController alloc] init];
                [ws.navigationController pushViewController:controller animated:YES];
            }else{
                [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
            }
        } failureBlcok:^(NSError *error) {
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
        }];
    }else{
        YGDefaultSessionController *controller = [[YGDefaultSessionController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)dealloc{
    [self.beginMyWorkoutPlayer stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
