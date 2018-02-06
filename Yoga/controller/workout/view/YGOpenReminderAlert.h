//
//  YGOpenReminderAlert.h
//  Yoga
//
//  Created by lyj on 2017/10/17.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGBaseAlert.h"
#import <UIKit/UIKit.h>

@interface YGOpenReminderAlert : YGBaseAlert
@property (nonatomic,strong) UIButton *openReminderBtn;
@property (nonatomic,strong) UIButton *notShowAgainBtn;

/**
 0完成页面  1回退页面
 */
@property (nonatomic) NSInteger type;
@end
