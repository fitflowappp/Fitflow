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

@implementation YGSinglesListCommand
-(void)execute{
    NSString *requestUrl = URLForge(@"/yoga/challenge/single/workout");
    [self sendRequestWithUrl:requestUrl method:GET];
}

-(void)successHandle:(id)data{
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
}

-(void)errorHandle:(NSError *)error{
    self.errorBlock(error);
}
@end
