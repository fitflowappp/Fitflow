//
//  YGSession.m
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGSession.h"
#import "YGRoutine.h"
#import "YGStringUtil.h"
@implementation YGSession
+(YGSession*)objectFrom:(NSDictionary*)dictionary{
    YGSession *session = [[YGSession alloc] init];
    if ([YGStringUtil notNull:dictionary]) {
        session.ID = [dictionary objectForKey:@"id"];
        session.status = [dictionary objectForKey:@"status"];
        session.avail = [dictionary objectForKey:@"avail"];
        session.duration = [dictionary objectForKey:@"duration"];
        session.currentRoutineID = [dictionary objectForKey:@"currentRoutineId"];
        session.coverImg = [YGImage objectFrom:[dictionary objectForKey:@"coverImg"]];
        NSString *title = [dictionary objectForKey:@"title"];
        if ([YGStringUtil notNull:title]) {
            session.title = title;
        }
        NSString *message = [dictionary objectForKey:@"message"];
        if ([YGStringUtil notNull:message]) {
            session.message = message;
        }
        NSString *sessionDescription = [dictionary objectForKey:@"description"];
        if ([YGStringUtil notNull:sessionDescription]) {
            session.sessionDescription = sessionDescription;
        }
        /*routineList*/
        NSArray *routines = [dictionary objectForKey:@"routines"];
        if ([YGStringUtil notNull:routines]) {
            for (NSDictionary *routineDictionary in routines) {
                YGRoutine *routine = [YGRoutine objectFrom:routineDictionary];
                if (routine.videoUrl) {
                    [session.routineList addObject:routine];
                    if (routine.display.boolValue==YES) {
                        [session.displayRoutineList addObject:routine];
                    }
                }
            }
        }
    }
    return session;
}

-(id)init{
    self = [super init];
    if (self) {
        self.routineList = [NSMutableArray array];
        self.displayRoutineList = [NSMutableArray array];
    }
    return self;
}
@end
