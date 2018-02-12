//
//  YGChallenge.h
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGImage.h"
@interface YGChallenge : NSObject
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSNumber *avail;
@property (nonatomic,strong) NSString *title;//
@property (nonatomic,strong) NSNumber *status;
@property (nonatomic,strong) NSNumber *seconds;
@property (nonatomic,strong) NSString *subTitle;//
@property (nonatomic,strong) YGImage  *coverImg;//
@property (nonatomic,strong) NSString *currentWorkoutID;
@property (nonatomic,strong) NSString *currentRoutineID;
@property (nonatomic,strong) NSMutableArray *workoutList;//
@property (nonatomic,strong) NSString *challengeDescription;//
+(YGChallenge*)objectFrom:(NSDictionary*)dictionary;
@end
