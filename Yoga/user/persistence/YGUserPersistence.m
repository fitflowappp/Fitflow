//
//  YGUserPersistence.m
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGStringUtil.h"
#import "YGUserPersistence.h"

@implementation YGUserPersistence
+ (YGUserPersistence *)instance{
    static YGUserPersistence *userPersistence = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        userPersistence = [[YGUserPersistence alloc] init];
    });
    return userPersistence;
}
-(void)updateLocalUser:(id)data{
    if ([YGStringUtil notNull:data]) {
        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:data];
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"KEY_USER_DATA"];
    }
}
@end
