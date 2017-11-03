//
//  YGSession.h
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGImage.h"
@interface YGSession : NSObject
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSNumber *avail;
@property (nonatomic,strong) NSNumber *status;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSNumber *duration;
@property (nonatomic,strong) YGImage  *coverImg;
@property (nonatomic,strong) NSString *currentRoutineID;
@property (nonatomic,strong) NSString *sessionDescription;
@property (nonatomic,strong) NSMutableArray *routineList;
@property (nonatomic,strong) NSMutableArray *displayRoutineList;
+(YGSession*)objectFrom:(NSDictionary*)dictionary;
@end