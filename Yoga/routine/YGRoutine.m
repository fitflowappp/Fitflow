//
//  YGRoutine.m
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGRoutine.h"
#import "YGStringUtil.h"
@implementation YGRoutine
+(YGRoutine*)objectFrom:(NSDictionary*)dictionary{
    YGRoutine *routine = [[YGRoutine alloc] init];
    if ([YGStringUtil notNull:dictionary]) {
        routine.ID = [dictionary objectForKey:@"id"];
        routine.title = [dictionary objectForKey:@"title"];
        routine.avail = [dictionary objectForKey:@"avail"];
        routine.status   = [dictionary objectForKey:@"status"];
        routine.display  = [dictionary objectForKey:@"display"];
        routine.duration = [dictionary objectForKey:@"duration"];
        NSDictionary *videoInfo = [dictionary objectForKey:@"video"];
        if ([YGStringUtil notNull:videoInfo]) {
            routine.vedioID = [videoInfo objectForKey:@"id"];
            NSString *vedioUrl = [videoInfo objectForKey:@"contentUri"];
            if ([vedioUrl hasPrefix:@"http"]) {
                routine.videoUrl = vedioUrl;
            }else{
                routine.videoUrl = [NSString stringWithFormat:@"%@%@",cHttpRequestDomain,vedioUrl];
            }
        }
        routine.coverImg = [YGImage objectFrom:[dictionary objectForKey:@"coverImg"]];
    }
    return routine;
}

-(void)setTitle:(NSString *)title{
    if ([YGStringUtil notNull:title]) {
        _title = title;
    }
}
@end
