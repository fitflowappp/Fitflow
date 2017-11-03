//
//  YGUser.m
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGUser.h"
#import "YGStringUtil.h"
@implementation YGUser

-(id)init{
    self = [super init];
    if (self) {
        self.name = @"Unregistered User";
        self.sessionId = @"";
        self.profileUrl = @"";
    }
    return self;
}

-(void)setName:(NSString *)name{
    if ([YGStringUtil notNull:name]) {
        if ([name isEqualToString:_name]==NO) {
            _name = name;
        }
    }else{
        self.name = @"Unregistered User";
    }
}

-(void)setSessionId:(NSString *)sessionId{
    if ([YGStringUtil notNull:sessionId]) {
        if ([sessionId isEqualToString:_sessionId]==NO) {
            _sessionId = sessionId;
        }
    }
}

-(void)setProfileUrl:(NSString *)profileUrl{
    if ([YGStringUtil notNull:profileUrl]) {
        if ([profileUrl isEqualToString:_profileUrl]==NO) {
            _profileUrl = profileUrl;
        }
    }
}

-(BOOL)isLogin{
    BOOL islogin = YES;
    if (self.sessionId.length==0) {
        islogin = NO;
    }
    return islogin;
}
@end
