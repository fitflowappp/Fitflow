//
//  YGEmailLoginCommand.h
//  Yoga
//
//  Created by lyj on 2017/12/25.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGNetworkBaseCommand.h"

@interface YGEmailLoginCommand : YGNetworkBaseCommand
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *password;
@end
