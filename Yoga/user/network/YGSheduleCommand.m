//
//  YGSheduleCommand.m
//  Yoga
//
//  Created by lyj on 2017/10/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGStringUtil.h"
#import "YGSheduleCommand.h"

@implementation YGSheduleCommand
-(void)execute{
    NSString *requestUrl  = [NSString stringWithFormat:@"%@%@",cRequestDomain,@"/yoga/config"];
    [self sendRequestWithUrl:requestUrl method:PUT parameter:self.params];
    
}
-(void)successHandle:(id)data{
    NSDictionary *result = [data objectForKey:@"result"];
    self.successBlock(result);
}

-(void)errorHandle:(NSError *)error{
    self.errorBlock(error);
}

@end
