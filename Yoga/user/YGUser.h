//
//  YGUser.h
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGUser : NSObject
@property (nonatomic) BOOL   isLogin;
@property (nonatomic) BOOL   unRegistered;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *sessionId;
@property (nonatomic,strong) NSData   *profileData;

@property (nonatomic) BOOL isLogout;
@end
