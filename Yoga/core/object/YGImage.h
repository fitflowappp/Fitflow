//
//  YGImage.h
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGImage : NSObject
@property (nonatomic,assign) float scale;
@property (nonatomic,strong) NSString *Id;
@property (nonatomic,strong) NSNumber *width;
@property (nonatomic,strong) NSNumber *height;
@property (nonatomic,strong) NSString *coverUrl;
+(YGImage*)objectFrom:(id)dictionary;
@end
