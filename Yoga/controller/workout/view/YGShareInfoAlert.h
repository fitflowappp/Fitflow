//
//  YGShareInfoAlert.h
//  Yoga
//
//  Created by lyj on 2017/10/17.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGBaseAlert.h"
#import <UIKit/UIKit.h>

@interface YGShareInfoAlert : YGBaseAlert
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UIButton *cancelShareToFacebookBtn;
-(id)initWithFrame:(CGRect)frame shareInfo:(NSMutableArray*)shareInfoList;
@end
