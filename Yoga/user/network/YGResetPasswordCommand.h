//
//  YGResetPasswordCommand.h
//  Yoga
//
//  Created by lyj on 2017/12/27.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGNetworkBaseCommand.h"

@interface YGResetPasswordCommand : YGNetworkBaseCommand
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *password;
@end
