//
//  YGImage.m
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGImage.h"
#import "YGStringUtil.h"
@implementation YGImage
+(YGImage*)objectFrom:(id)dictionary{
    YGImage *img = [[YGImage alloc] init];
    if ([YGStringUtil notNull:dictionary]) {
        img.Id       = [dictionary objectForKey:@"id"];
        img.width    = [dictionary objectForKey:@"width"];
        img.height   = [dictionary objectForKey:@"height"];
        img.coverUrl = [NSString stringWithFormat:@"%@%@",cHttpRequestDomain,[dictionary objectForKey:@"contentUri"]];
    }
    return img;
}

-(float)scale{
    float scale = 1.0f;
    if (self.height.floatValue) {
        scale = self.height.floatValue/self.width.floatValue;
    }
    return scale;
}
@end
