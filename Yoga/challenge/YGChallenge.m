//
//  YGChallenge.m
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGChallenge.h"
#import "YGStringUtil.h"
#import "YGSession.h"
@implementation YGChallenge
+(YGChallenge*)objectFrom:(NSDictionary*)dictionary{
    YGChallenge *challenge = [[YGChallenge alloc] init];
    if ([YGStringUtil notNull:dictionary]) {
        challenge.ID = [dictionary objectForKey:@"id"];
        challenge.seconds = [dictionary objectForKey:@"seconds"];
        challenge.avail = [dictionary objectForKey:@"avail"];
        challenge.status = [dictionary objectForKey:@"status"];
        challenge.coverImg = [YGImage objectFrom:[dictionary objectForKey:@"coverImg"]];
        NSString *currentWorkoutID = [dictionary objectForKey:@"currentWorkoutId"];
        if ([YGStringUtil notNull:currentWorkoutID]) {
            challenge.currentWorkoutID = currentWorkoutID;
        }
        NSString *currentRoutineID = [dictionary objectForKey:@"currentRoutineId"];
        if ([YGStringUtil notNull:currentRoutineID]) {
            challenge.currentRoutineID = currentRoutineID;
        }
        NSString *title = [dictionary objectForKey:@"title"];
        if ([YGStringUtil notNull:title]) {
            challenge.title = title;
        }
        NSString *subTitle = [dictionary objectForKey:@"subTitle"];
        if ([YGStringUtil notNull:subTitle]) {
            challenge.subTitle = subTitle;
        }
        NSString *challengeDescription = [dictionary objectForKey:@"description"];
        if ([YGStringUtil notNull:challengeDescription]) {
            challenge.challengeDescription = challengeDescription;
        }
        /*workoutLiteList*/
        NSArray *workouts = [dictionary objectForKey:@"workouts"];
        if ([YGStringUtil notNull:workouts]) {
            for (NSDictionary * dictionary in workouts) {
                YGSession *session = [YGSession objectFrom:dictionary];
                [challenge.workoutList addObject:session];
            }
        }
    }
    return challenge;
}

-(id)init{
    self = [super init];
    if (self) {
        self.workoutList = [NSMutableArray array];
        self.challengeDescription = @"";
    }
    return self;
}
@end
