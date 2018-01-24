//
//  NSString+MD5.h
//  Yoga
//
//  Created by lyj on 2017/12/27.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>  
@interface NSString (MD5)
-(NSString*)md5;
@end
