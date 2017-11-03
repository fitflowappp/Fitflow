//
//  RDDeviceUtil.m
//  Reading
//
//  Created by lyj on 17/8/24.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGDeviceUtil.h"

@implementation YGDeviceUtil
+(NSString*)version{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *shortVersionStr = infoDic[@"CFBundleShortVersionString"];
    NSString *bundleVersionStr = infoDic[@"CFBundleVersion"];
    NSString *version= [NSString stringWithFormat:@"%@(%@)", shortVersionStr, bundleVersionStr];
    return version;
}

@end
