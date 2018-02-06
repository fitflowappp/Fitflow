//
//  YGDeepLinkUtil.h
//  Yoga
//
//  Created by 何侨 on 2018/2/6.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGDeepLinkUtil : NSObject

/** 存储link或者跳转 */
+ (void)linkWithDeepLinkParamter:(NSDictionary *)params;
/** 查找本地link是否存在 */
+ (BOOL)isExistDeepLinkParamsKey;
/** 跳转存储的link */
+ (void)pushToSaveDeepLinkParams;

@end
