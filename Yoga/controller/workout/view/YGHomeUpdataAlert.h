//
//  YGHomeUpdataAlert.h
//  Yoga
//
//  Created by 何侨 on 2018/1/25.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGBaseAlert.h"

@interface YGHomeUpdataAlert : YGBaseAlert

/**
 初始化：type: 1 强制 0 非强制
 */
- (instancetype)initWithFrame:(CGRect)frame contentTittle:(NSString*)tittle UpdataType:(NSInteger)type;


@property (nonatomic,weak) UIButton *updataBtn;
@end
