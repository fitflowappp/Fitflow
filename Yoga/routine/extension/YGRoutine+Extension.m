//
//  YGRoutine+Extension.m
//  Yoga
//
//  Created by lyj on 2017/9/20.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGStringUtil.h"
#import "YGRoutine+Extension.h"
@implementation YGRoutine (Extension)
-(BOOL)downLoaded{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self videoInSandboxPath]];
}

-(NSString*)videoInSandboxPath{
    return [YGStringUtil relativePathToFullSandboxPath:[NSString stringWithFormat:@"routine/%@.mp4",self.vedioID]];
}

@end
