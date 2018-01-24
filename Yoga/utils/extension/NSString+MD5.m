//
//  NSString+MD5.m
//  Yoga
//
//  Created by lyj on 2017/12/27.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "NSString+MD5.h"

@implementation NSString (MD5)
-(NSString*)md5{
    const char *str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *md5String = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [md5String appendFormat:@"%02x", result[i]];
    return  md5String;
}
@end
