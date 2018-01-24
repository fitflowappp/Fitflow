//
//  YGDiscoverController.m
//  Yoga
//
//  Created by lyj on 2018/1/2.
//  Copyright © 2018年 lyj. All rights reserved.
//
#import "YGDiscoverOptionView.h"
#import "YGDiscoverController.h"
#import "YGSinglesListController.h"
#import "YGChallengeListController.h"
@interface YGDiscoverController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) YGDiscoverOptionView *discoverOptionView;
@property (nonatomic,strong) YGSinglesListController   *singlesListController;
@property (nonatomic,strong) YGChallengeListController *challengeListController;
@end

@implementation YGDiscoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"DISCOVER";
    [self addDiscoverOptionView];
    [self addContentScrollView];
    [self setChildControllers];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = nil;
}

-(void)addDiscoverOptionView{
    self.discoverOptionView = [[YGDiscoverOptionView alloc] initWithFrame:CGRectMake(0,0,GET_SCREEN_WIDTH,24)];
    [self.view addSubview:self.discoverOptionView];
    [self.discoverOptionView.challengesBtn addTarget:self action:@selector(didSelectChallenges:) forControlEvents:UIControlEventTouchUpInside];
    [self.discoverOptionView.singlesBtn addTarget:self action:@selector(didSelectSingles:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addContentScrollView{
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,24,GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT-NAV_HEIGHT-TAB_BAR_HEIGHT-24)];
    self.contentScrollView.contentSize = CGSizeMake(GET_SCREEN_WIDTH*2,0);
    self.contentScrollView.bounces = NO;
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.contentScrollView];
    if (self.optionIndex==1) {
        [self didSelectSingles:nil];
    }
}

-(void)setChildControllers{
    self.challengeListController = [[YGChallengeListController alloc] init];
    [self addChildViewController:self.challengeListController];
    [self.contentScrollView addSubview:self.challengeListController.view];
    self.singlesListController = [[YGSinglesListController alloc] init];
    [self addChildViewController:self.singlesListController];
    [self.contentScrollView addSubview:self.singlesListController.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.discoverOptionView.optionIndex = index;
}

-(void)didSelectChallenges:(UIButton*)sender{
    if (self.discoverOptionView.optionIndex==1) {
        self.discoverOptionView.optionIndex = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.contentScrollView.contentOffset = CGPointZero;
        }];
    }
}

-(void)didSelectSingles:(UIButton*)sender{
    if (self.discoverOptionView.optionIndex==0) {
        self.discoverOptionView.optionIndex = 1;
        [UIView animateWithDuration:0.2 animations:^{
            self.contentScrollView.contentOffset = CGPointMake(GET_SCREEN_WIDTH,0);
        }];
    }
}

-(void)setOptionIndex:(int)index{
    _optionIndex = index;
    if ([self viewIfLoaded]) {
        if (index==0) {
            [self didSelectChallenges:nil];
        }else{
            [self didSelectSingles:nil];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
