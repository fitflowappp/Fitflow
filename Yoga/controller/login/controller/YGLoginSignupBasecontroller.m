//
//  YGLoginSignupBasecontroller.m
//  Yoga
//
//  Created by lyj on 2017/12/22.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGLoginSignupBasecontroller.h"

@interface YGLoginSignupBasecontroller ()

@end

@implementation YGLoginSignupBasecontroller

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setUpSubviews{
    [self addBackGroundImgv];
    [self addDarkv];
    [self addBackBtn];
}

-(void)addBackGroundImgv{
    self.backGroundImgv = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backGroundImgv.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backGroundImgv];
}

-(void)addDarkv{
    self.darkv = [[UIView alloc] initWithFrame:self.view.bounds];
    self.darkv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.view addSubview:self.darkv];
    [self.darkv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTextField)]];
}

-(void)addBackBtn{
    CGFloat marginX = (56/375.0)*self.view.frame.size.width;
    CGFloat marginY  = IS_IPHONE_X?72:35*SCALE;;
    UIImage *img = [UIImage imageNamed:@"left-white"];
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(marginX,marginY,img.size.width,img.size.height);
    [self.backBtn setImage:img forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
}

#pragma mark

-(void)back{
    NSLog(@"subclass should cover this mhtehod");
}

-(void)hideTextField{
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UITextField class]]) {
            [(UITextField*)v resignFirstResponder];
        }
    }
}
@end
