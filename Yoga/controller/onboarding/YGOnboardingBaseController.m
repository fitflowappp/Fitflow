//
//  YGOnboardingBaseController.m
//  Yoga
//
//  Created by lyj on 2017/12/21.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGOnboardingBaseController.h"

@interface YGOnboardingBaseController ()
@property (nonatomic,strong) UIView  *firstStepv;
@property (nonatomic,strong) UIView  *secondStepv;
@property (nonatomic,strong) UIView  *thirdStepv;
@property (nonatomic,strong) UILabel *stepIndexLabel;
@end

@implementation YGOnboardingBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)setUpSubviews{
    [self addBackGroundImgv];
    [self addDarkv];
    [self addBackBtn];
    [self addStepIndexLabel];
    [self addStepView];
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

-(void)addTitleLabelWithText:(NSString*)text{
    CGFloat marginX = (56/375.0)*self.view.frame.size.width;
    CGFloat marginY = CGRectGetMaxY(self.backBtn.frame)+16*SCALE;
    CGFloat Width   = self.view.frame.size.width-marginX*2;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX,marginY,Width,48*SCALE)];
    self.titleLabel.text = text;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:24];
    [self.titleLabel sizeToFit];
    [self.view addSubview:self.titleLabel];
}

-(void)addStepIndexLabel{
    CGFloat marginY = self.view.frame.size.height-24*SCALE-16;
    self.stepIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,marginY,self.view.frame.size.width,16)];
    self.stepIndexLabel.textAlignment = NSTextAlignmentCenter;
    self.stepIndexLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.stepIndexLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    [self.view addSubview:self.stepIndexLabel];
}

-(void)addStepView{
    self.secondStepv = [self creatStepv];
    self.secondStepv.center = CGPointMake(self.view.center.x,self.stepIndexLabel.frame.origin.y-8*SCALE-self.secondStepv.frame.size.height/2);
    [self.view addSubview:self.secondStepv];
    //
    self.firstStepv = [self creatStepv];
    self.firstStepv.backgroundColor = [UIColor colorWithHexString:@"#41D395"];
    self.firstStepv.center = CGPointMake(self.secondStepv.frame.origin.x-1-self.firstStepv.frame.size.width/2,self.secondStepv.center.y);
    [self.view addSubview:self.firstStepv];
    //
    self.thirdStepv = [self creatStepv];
    self.thirdStepv.center = CGPointMake(CGRectGetMaxX(self.secondStepv.frame)+1+self.thirdStepv.frame.size.width/2,self.secondStepv.center.y);
    [self.view addSubview:self.thirdStepv];
}

-(UIView*)creatStepv{
    UIView *stepv = [[UIView alloc] initWithFrame:CGRectMake(0,0,(48/375.0)*self.view.frame.size.width,4*SCALE)];
    stepv.backgroundColor = [UIColor whiteColor];
    return stepv;
}

-(void)setOnboardingStep:(int)step{
    self.stepIndexLabel.text = [NSString stringWithFormat:@"%d/3",step];
    if (step>1) {
        self.secondStepv.backgroundColor = [UIColor colorWithHexString:@"#41D395"];
        self.thirdStepv.backgroundColor = step==3?[UIColor colorWithHexString:@"#41D395"]:[UIColor whiteColor];
    }else{
        self.secondStepv.backgroundColor = [UIColor whiteColor];
        self.thirdStepv.backgroundColor = [UIColor whiteColor];
    }
}
#pragma mark

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
