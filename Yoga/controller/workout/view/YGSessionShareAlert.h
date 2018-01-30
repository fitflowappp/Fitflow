//
//  YGSessionShareAlert.h
//  Yoga
//
//  Created by 何侨 on 2018/1/29.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGBaseAlert.h"

@interface YGSessionShareAlert : YGBaseAlert
-(id)initWithFrame:(CGRect)frame contentTittle:(NSString*)tittle;
@property (nonatomic,strong) UIButton *changeBtn;
@end
