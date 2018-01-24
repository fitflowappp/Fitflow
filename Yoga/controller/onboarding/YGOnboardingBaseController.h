//
//  YGOnboardingBaseController.h
//  Yoga
//
//  Created by lyj on 2017/12/21.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGBaseController.h"

@interface YGOnboardingBaseController : YGBaseController
@property (nonatomic,strong) UIView   *darkv;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UILabel  *titleLabel;
@property (nonatomic,strong) UIImageView *backGroundImgv;
-(void)setUpSubviews;
-(void)setOnboardingStep:(int)step;
-(void)addTitleLabelWithText:(NSString*)text;
@end
