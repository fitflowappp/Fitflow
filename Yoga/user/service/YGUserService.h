//
//  YGUserService.h
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGUser.h"
#import <Foundation/Foundation.h>

@interface YGUserService : NSObject
+ (YGUserService *)instance;

-(YGUser*)localUser;

@end
