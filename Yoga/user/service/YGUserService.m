//
//  YGUserService.m
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "GTMBase64.h"
#import "YGStringUtil.h"
#import "YGUserService.h"
#import "YGAnonymousLoginCommand.h"

@interface YGUserService ()
@property (nonatomic,strong) YGUser *localUser;
@end

@implementation YGUserService
+ (YGUserService *)instance{
    static YGUserService *userService = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        userService = [[YGUserService alloc] init];
    });
    return userService;
}

-(id)init{
    self = [super init];
    if (self) {
        _localUser = [[YGUser alloc] init];
    }
    return self;
}

-(YGUser*)localUser{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_LOCAL_DATA];
    if ([YGStringUtil notNull:userData]) {
        NSDictionary *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        _localUser.name = [userInfo objectForKey:@"name"];
        _localUser.email= [userInfo objectForKey:@"email"];
        _localUser.sessionId= [userInfo objectForKey:@"sessionId"];
        _localUser.unRegistered = [[userInfo objectForKey:@"unRegistered"] boolValue];
        NSString *headerImgContent = [userInfo objectForKey:@"headerImgContent"];
        if ([YGStringUtil notNull:headerImgContent]) {
            NSData *strData = [headerImgContent dataUsingEncoding:NSUTF8StringEncoding];
            const void *bytes = [strData bytes];
            _localUser.profileData = [GTMBase64 decodeBytes:bytes length:[strData length]];
        }else{
            _localUser.profileData = nil;
        }
    }
    return _localUser;
}
@end
