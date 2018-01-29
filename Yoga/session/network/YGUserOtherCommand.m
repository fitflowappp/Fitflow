//
//  YGUserOtherCommand.m
//  Yoga
//
//  Created by 何侨 on 2018/1/25.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGUserOtherCommand.h"
#import "YGStringUtil.h"

@implementation YGUserOtherCommand
-(void)execute{
    NSString *requestUrl = URLForge(@"/user/version/update");
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
    parameters[@"system"] = @"1";
    parameters[@"version"] = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    parameters[@"build"] = [infoDictionary objectForKey:@"CFBundleVersion"];
    [self sendRequestWithUrl:requestUrl method:POST parameter:parameters];
}

-(void)successHandle:(id)data{
    NSDictionary *result = [data objectForKey:@"result"];
    int code = [[result objectForKey:@"code"] intValue];
    NSMutableDictionary *response = [NSMutableDictionary dictionaryWithCapacity:3];
    if (code == 1 && data[@"content"] && ![data[@"content"] isKindOfClass:[NSNull class]]) {
        response[@"desc"] = data[@"content"][@"desc"];
        response[@"type"] = data[@"content"][@"type"];
        response[@"downloadUrl"] = data[@"content"][@"downloadUrl"];
        self.successBlock(response);
    }
}

-(void)errorHandle:(NSError *)error{
    self.errorBlock(error);
}
@end
