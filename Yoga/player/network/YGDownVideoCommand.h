//
//  YGDownLoadVideoCommand.h
//  Yoga
//
//  Created by lyj on 2017/9/20.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGNetworkBaseCommand.h"

@interface YGDownVideoCommand : YGNetworkBaseCommand
@property (nonatomic,copy) NSString *requestUrl;
@property (nonatomic,strong) NSString *filePath;
-(void)downVideoWithRequestUrl:(NSString *)url filePath:(NSString*)filePath;
@end
