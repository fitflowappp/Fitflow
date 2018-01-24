//
//  UIColor+Extension.h
//  Reading
//
//  Created by lyj on 17/8/16.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)
+ (UIColor*)colorWithHexString:(NSString*)hexString;
+ (UIImage *)imageWithHexString:(NSString*)hexString;
+ (UIColor*)colorWithRGBHex:(UInt32)hex alpha:(float)alpha;
+ (UIColor*)colorWithHexString:(NSString*)hexString alpha:(float)alpha;
@end
