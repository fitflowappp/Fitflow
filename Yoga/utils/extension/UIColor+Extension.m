//
//  UIColor+Extension.m
//  Reading
//
//  Created by lyj on 17/8/16.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGStringUtil.h"
#import "UIColor+Extension.h"
@implementation UIColor (Extension)
+ (UIColor*)colorWithHexString:(NSString*)hexString{
//    if ([YGStringUtil isNull:hexString]||hexString.length==0) {
//        return [UIColor blackColor];
//    }
//    if([hexString hasPrefix:@"#"])
//    {
//        hexString = [hexString substringFromIndex:1];
//    }
//    NSScanner*scanner = [NSScanner scannerWithString:hexString];
//    unsigned hexNum;
//    if(![scanner scanHexInt:&hexNum])
//    {
//        return [UIColor blackColor];
//    }
//    return[UIColor colorWithRGBHex:hexNum alpha:1];
    return [UIColor colorWithHexString:hexString alpha:1];
}

+ (UIColor*)colorWithHexString:(NSString*)hexString alpha:(float)alpha{
    if ([YGStringUtil isNull:hexString]||hexString.length==0) {
        return [UIColor blackColor];
    }
    if([hexString hasPrefix:@"#"])
    {
        hexString = [hexString substringFromIndex:1];
    }
    NSScanner*scanner = [NSScanner scannerWithString:hexString];
    unsigned hexNum;
    if(![scanner scanHexInt:&hexNum])
    {
        return [UIColor blackColor];
    }
    return[UIColor colorWithRGBHex:hexNum alpha:alpha];
    
}

+ (UIColor*)colorWithRGBHex:(UInt32)hex alpha:(float)alpha{
    int r = (hex >>16) &0xFF;
    int g = (hex >>8) &0xFF;
    int b = (hex) &0xFF;
    return[UIColor colorWithRed:r /255.0f
                          green:g /255.0f
                           blue:b /255.0f
                          alpha:alpha];
}
+ (UIImage *)imageWithHexString:(NSString*)hexString{
    UIColor *color = [UIColor colorWithHexString:hexString];
    CGRect rect=CGRectMake(0.0f, 0.0f,1,1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
