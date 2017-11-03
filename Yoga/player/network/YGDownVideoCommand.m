//
//  YGDownLoadVideoCommand.m
//  Yoga
//
//  Created by lyj on 2017/9/20.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGFileUtil.h"
#import "YGUserService.h"
#import "YGDownVideoCommand.h"

@implementation YGDownVideoCommand
-(void)execute{
    [self downVideoWithRequestUrl:self.requestUrl filePath:self.filePath];
}
-(void)downVideoWithRequestUrl:(NSString *)url filePath:(NSString*)filePath{
    NSString *encodingURLString=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest * request=[[self networkEngine].requestSerializer requestWithMethod:@"GET" URLString:encodingURLString parameters:nil error:nil];
    [request setValue:[[YGUserService instance] localUser].sessionId forHTTPHeaderField:@"Authorization"];
    NSURLSessionDownloadTask *task =  [[self networkEngine] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        /*下载进度*/
        //NSLog(@"routine down progress :%f",downloadProgress.fractionCompleted);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:self.filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (!error) {
            if (self.successBlock) {
                self.successBlock(@(YES));
            }
        }else{
            if (self.errorBlock) {
                self.errorBlock(error);
            }
        }
    }];
    [task resume];
    
}
@end
