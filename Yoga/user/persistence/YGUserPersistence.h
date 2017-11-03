//
//  YGUserPersistence.h
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGUserPersistence : NSObject
+ (YGUserPersistence *)instance;

-(void)updateLocalUser:(id)data;
@end
