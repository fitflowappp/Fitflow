//
//  YGLoginSignupBasecontroller.h
//  Yoga
//
//  Created by lyj on 2017/12/22.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGBaseController.h"

@interface YGLoginSignupBasecontroller : YGBaseController
@property (nonatomic,strong) UIView   *darkv;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIImageView *backGroundImgv;
-(void)setUpSubviews;
@end
