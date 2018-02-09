//
//  ViewController.m
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import <Social/Social.h>
#import "YGAppDelegate.h"
#import "YGBaseController.h"
#import "YGShareCompleteViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface YGBaseController ()
@end
@implementation YGBaseController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scale = SCALE;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.view.backgroundColor = [UIColor whiteColor];
    if ( [self respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    YGAppDelegate *appDelegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.forceLandscape = NO;
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    NSLog(@"msg: %@ dealloc",NSStringFromClass([self class]));
}

-(void)setLeftNavigationItem{
    UIImage *itemImg = [UIImage imageNamed:@"Left-green"];
    UIButton *leftItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItemBtn.frame = CGRectMake(0,0,48,44);
    [leftItemBtn setImage:itemImg forState:UIControlStateNormal];
    [leftItemBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftItemBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 44);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItemzero = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *buttonItemone = [[UIBarButtonItem alloc] initWithCustomView:leftItemBtn];
    self.navigationItem.leftBarButtonItems = @[buttonItemone, buttonItemzero];
}

-(void)setRightShareNavigationItem{
    UIImage *itemImg = [UIImage imageNamed:@"Right-share"];
    UIButton *rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemBtn.frame = CGRectMake(0,0,48,44);
    [rightItemBtn setImage:itemImg forState:UIControlStateNormal];
    [rightItemBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightItemBtn addTarget:self action:@selector(didSelectShareItem) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 44);
    [button addTarget:self action:@selector(didSelectShareItem) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItemzero = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *buttonItemone = [[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
    
    self.navigationItem.rightBarButtonItems = @[buttonItemone, buttonItemzero];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didSelectShareItem{
    NSLog(@"Error, SubClass must override this method!");
}

-(void)didSelectShareCompleted{
    YGShareCompleteViewController *controller = [YGShareCompleteViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)retryWhenNetworkError{
    NSLog(@"Error, SubClass must override this method!");
}

-(void)shareWithContent:(NSArray*)content{
    [FBSDKAppEvents logEvent:FBEVENTUPDATEKEY_SHARE];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:content applicationActivities:nil];
        NSMutableArray *excludedActivityTypes = [NSMutableArray array];
        [excludedActivityTypes addObject:UIActivityTypeAirDrop];
        if ([UIDevice currentDevice].systemVersion.floatValue>=11.0) {
            [excludedActivityTypes addObject:UIActivityTypePostToFacebook];
            [excludedActivityTypes addObject:UIActivityTypePostToTwitter];
        }
        controller.excludedActivityTypes = excludedActivityTypes;
        if ([controller respondsToSelector:@selector(popoverPresentationController)]) {
            controller.popoverPresentationController.sourceView = self.view;
        }
        [controller setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if (completed==YES) {
                NSLog(@"msg: share completed");
                [self didSelectShareCompleted];
            }else{
                if (activityError) {
                    NSLog(@"msg: share error:%@",activityError.localizedDescription);
                }else{
                    NSLog(@"msg: share canceled");
                }
            }
        }];
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    });
}

@end
