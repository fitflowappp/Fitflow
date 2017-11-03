//
//  ViewController.m
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//

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
}

-(void)setLeftNavigationItem{
    UIImage *itemImg = [UIImage imageNamed:@"Left-green"];
    UIButton *leftItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItemBtn.frame = CGRectMake(0.0,(60-itemImg.size.height)/2, itemImg.size.width, itemImg.size.height);
    [leftItemBtn setImage:itemImg forState:UIControlStateNormal];
    [leftItemBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:leftItemBtn];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)shouldAutorotate{
    return NO;
}

-(void)retryWhenNetworkError{
    

}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return  UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return  UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    NSLog(@"msg: %@ dealloc",NSStringFromClass([self class]));
}
@end
