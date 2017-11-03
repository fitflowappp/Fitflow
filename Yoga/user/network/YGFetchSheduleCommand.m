//
//  YGFetchSheduleCommand.m
//  Yoga
//
//  Created by lyj on 2017/10/13.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGStringUtil.h"
#import "YGFetchSheduleCommand.h"

@implementation YGFetchSheduleCommand
-(void)execute{
    NSString *requestUrl  = [NSString stringWithFormat:@"%@%@",cRequestDomain,@"/yoga/config"];
    [self sendRequestWithUrl:requestUrl method:GET];
    
}
-(void)successHandle:(id)data{
    NSMutableDictionary *scheduleInfo =nil;
    NSDictionary *result = [data objectForKey:@"result"];
    int code = [[result objectForKey:@"code"] intValue];
    if (code==1) {
        NSDictionary *content = [data objectForKey:@"content"];
        if ([YGStringUtil notNull:content]) {
            scheduleInfo = [NSMutableDictionary dictionaryWithDictionary:content];
            [scheduleInfo setObject:[NSMutableArray arrayWithArray:[content objectForKey:@"schedulingDays"]] forKey:@"schedulingDays"];
        }
        
        
        
//        NSNumber *reminder = [content objectForKey:@"remider"];
//        NSNumber *openPush = [content objectForKey:@"notification"];
//        NSMutableArray *sheduleDays = [NSMutableArray arrayWithArray:[content objectForKey:@"schedulingDays"]];
//        [scheduleInfo setObject:reminder forKey:@"reminder"];
//        [scheduleInfo setObject:openPush forKey:@"openPush"];
//        [scheduleInfo setObject:sheduleDays forKey:@"sheduleDays"];
//        [scheduleInfo setObject:reminder forKey:@"reminder"];
    }
    self.successBlock(scheduleInfo);
}

-(void)errorHandle:(NSError *)error{
    self.errorBlock(error);
}
@end
