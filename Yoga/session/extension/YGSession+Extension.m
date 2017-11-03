//
//  YGSession+Extension.m
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "objc/runtime.h"
#import "YGSession+Extension.h"

@implementation YGSession (Extension)
@dynamic decriptionHeight;
@dynamic attributedDescription;
-(NSNumber*)decriptionHeight{
    return objc_getAssociatedObject(self, @selector(decriptionHeight));
}

-(void)setDecriptionHeight:(NSNumber*)decriptionHeight{
    objc_setAssociatedObject(self, @selector(decriptionHeight), decriptionHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableAttributedString*)attributedDescription{
    return objc_getAssociatedObject(self, @selector(attributedDescription));
}

-(void)setAttributedDescription:(NSMutableAttributedString*)attributedDescription{
    objc_setAssociatedObject(self, @selector(attributedDescription), attributedDescription, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)complete{
    BOOL ret = NO;
    if (self.routineList.count) {
        YGRoutine *lastRoutine = self.routineList.lastObject;
        if (lastRoutine.status.intValue>2) {
            ret = YES;
        }
    }
    return ret;
}

-(YGRoutine*)currentRoutine{
    YGRoutine *routine = nil;
    if (self.routineList.count) {
        int currentRoutineIndex = 0;
        for (int i=0; i<self.routineList.count;i++) {
            YGRoutine *routine = self.routineList[i];
            if (routine.status.intValue<3) {
                currentRoutineIndex = i;
                break;
            }
        }
        routine = self.routineList[currentRoutineIndex];
    }
    return routine;
}
@end
