//
//  YGChangeChallengeAlertView.h
//  Yoga
//
//  Created by lyj on 2017/9/27.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGBaseAlert.h"
@interface YGChangeChallengeAlert : YGBaseAlert
-(id)initWithFrame:(CGRect)frame contentTittle:(NSString*)tittle;
@property (nonatomic,strong) UIButton *changeBtn;
@end
