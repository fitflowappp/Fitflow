//
//  RDKeychainUtil.m
//  Reading
//
//  Created by lyj on 2017/9/15.
//  Copyright © 2017年 lyj. All rights reserved.
//
#define KEY_IN_KEYCHAIN @"keyInKeyChain"
#import "YGKeychainUtil.h"

@implementation YGKeychainUtil
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
                          service, (__bridge_transfer id)kSecAttrService,
                          service, (__bridge_transfer id)kSecAttrAccount,
                          (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
                          nil];
    NSMutableDictionary * mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    return mutableDic;
}

+ (void)save:(NSDictionary *)pairs {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:KEY_IN_KEYCHAIN];
    //Delete old item before add new item
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:pairs] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)key {
    NSDictionary *dic = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:KEY_IN_KEYCHAIN];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            dic = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", KEY_IN_KEYCHAIN, e);
        } @finally {
        }
    }
    return [dic objectForKey:key];
}

+ (void)deleteAppKeychain {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:KEY_IN_KEYCHAIN];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}
@end
