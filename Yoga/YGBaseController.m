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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBtn];
    if (self.view.frame.size.width>375) {
        leftItemBtn.imageEdgeInsets =UIEdgeInsetsMake(0,-4,0, 0);
        leftItemBtn.contentEdgeInsets =UIEdgeInsetsMake(0,-4,0,0);
    }else{
        leftItemBtn.imageEdgeInsets =UIEdgeInsetsMake(0,-2,0, 0);
        leftItemBtn.contentEdgeInsets =UIEdgeInsetsMake(0,-2,0,0);
    }
}

-(void)setRightShareNavigationItem{
    UIImage *itemImg = [UIImage imageNamed:@"Right-share"];
    UIButton *rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemBtn.frame = CGRectMake(0,0,48,44);
    [rightItemBtn setImage:itemImg forState:UIControlStateNormal];
    [rightItemBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightItemBtn addTarget:self action:@selector(didSelectShareItem) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
    if (self.view.frame.size.width>375) {
        rightItemBtn.imageEdgeInsets =UIEdgeInsetsMake(0,0,0,-2);
        rightItemBtn.contentEdgeInsets =UIEdgeInsetsMake(0,0,0,-2);
    }else{
        rightItemBtn.imageEdgeInsets =UIEdgeInsetsMake(0,0,0,-2);
        rightItemBtn.contentEdgeInsets =UIEdgeInsetsMake(0,0,0,-2);
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didSelectShareItem{
    NSLog(@"Error, SubClass must override this method!");;
}

-(void)retryWhenNetworkError{
    NSLog(@"Error, SubClass must override this method!");
}

-(void)shareWithContent:(NSArray*)content{
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
