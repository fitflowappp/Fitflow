//
//  YGRoutine.h
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGRoutine : NSObject
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *vedioID;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSNumber *avail;
@property (nonatomic,strong) NSNumber *status;
@property (nonatomic,strong) NSNumber *display;
@property (nonatomic,strong) NSNumber *duration;
@property (nonatomic,strong) NSNumber *seconds;
@property (nonatomic,strong) NSString *videoUrl;
+(YGRoutine*)objectFrom:(NSDictionary*)dictionary;
@end
