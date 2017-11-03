//
//  RDKeychainUtil.h
//  Reading
//
//  Created by lyj on 2017/9/15.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGKeychainUtil : NSObject
+ (void)save:(NSDictionary *)pairs;
+ (id)load:(NSString *)key;
+ (void)deleteAppKeychain;
@end
