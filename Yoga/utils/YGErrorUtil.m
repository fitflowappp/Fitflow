//
//  HHErrorUtil.m
//  KaDa
//
//  Created by YangYang on 15/2/2.
//  Copyright (c) 2015年 YangYang. All rights reserved.
//

#import "YGErrorUtil.h"

@implementation YGErrorUtil

+ (NSError *)getError
{
    return [NSError errorWithDomain:@"" code:0 userInfo:nil];
}

+ (NSString *)getErrorMessage:(NSError *)error
{
    [error localizedFailureReason];
    [error code];
    [error userInfo];
    return [[error userInfo] description];
}

@end
