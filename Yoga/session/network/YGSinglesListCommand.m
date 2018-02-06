//
//  YGSinglesListCommand.m
//  Yoga
//
//  Created by lyj on 2018/1/3.
//  Copyright © 2018年 lyj. All rights reserved.
//
#import "YGSession.h"
#import "YGStringUtil.h"
#import "YGSinglesListCommand.h"
#import "YGUserService.h"
@implementation YGSinglesListCommand
-(void)execute{
    NSString *requestUrl = nil;
    if (self.successBlock) {
       requestUrl = URLForge(@"/yoga/challenge/single/workout");
    } else if (self.locksuccessBlock) {
       requestUrl = URLForge(@"/yoga/app/workout/single/page");
    } else {
       requestUrl = URLForge(@"/yoga/app/workout/single/page/lock");
    }
    [self sendRequestWithUrl:requestUrl method:GET];
}

-(void)successHandle:(id)data{
    
    if (self.successBlock) {
        NSDictionary *result = [data objectForKey:@"result"];
        int code = [[result objectForKey:@"code"] intValue];
        NSMutableArray *singlesList = [NSMutableArray array];
        if (code ==1) {
            NSArray *content = [data objectForKey:@"content"];
            if ([YGStringUtil notEmpty:content]) {
                for (NSDictionary *dictionary in content) {
                    YGSession *session = [YGSession objectFrom:dictionary];
                    [singlesList addObject:session];
                }
            }
        }
        self.successBlock(singlesList);
        return;
    }
    
    if (self.locksuccessBlock) {
        NSMutableArray *singlesList = [NSMutableArray array];
        NSInteger totalElements = [data[@"totalElements"] integerValue];
        if (totalElements) {
            NSArray *content = [data objectForKey:@"content"];
            if ([YGStringUtil notEmpty:content]) {
                for (NSDictionary *dictionary in content) {
                    YGSession *session = [YGSession objectFrom:dictionary];
                    [singlesList addObject:session];
                }
            }
        }
        self.locksuccessBlock(singlesList);
        return;
    }
    
    
    NSMutableArray *singlesList = [NSMutableArray array];
    NSInteger totalElements = [data[@"totalElements"] integerValue];
    if (totalElements) {
        NSArray *content = [data objectForKey:@"content"];
        if ([YGStringUtil notEmpty:content]) {
            for (NSDictionary *dictionary in content) {
                YGSession *session = [YGSession objectFrom:dictionary];
                [singlesList addObject:session];
            }
        }
    }
    self.unlocksuccessBlock(singlesList);
   
}

-(void)errorHandle:(NSError *)error{
    if (self.errorBlock) {
        self.errorBlock(error);
        return;
    }
    if (self.lockerrorBlock) {
        self.lockerrorBlock(error);
        return;
    }
    self.unlockerrorBlock(error);
    
}


@end
