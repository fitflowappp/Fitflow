//
//  HHErrorUtil.h
//  KaDa
//
//  Created by YangYang on 15/2/2.
//  Copyright (c) 2015年 YangYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGErrorUtil : NSObject

+ (NSError *)getError;
+ (NSString *)getErrorMessage:(NSError *)error;

@end
