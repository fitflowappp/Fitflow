//
//  YGChallenge+Extension.m
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "objc/runtime.h"
#import "YGChallenge+Extension.h"

@implementation YGChallenge (Extension)
@dynamic decriptionHeight;
@dynamic isMineChallenge;
@dynamic attributedDescription;

-(NSNumber*)decriptionHeight{
    return objc_getAssociatedObject(self, @selector(decriptionHeight));
}

-(void)setDecriptionHeight:(NSNumber*)decriptionHeight{
    objc_setAssociatedObject(self, @selector(decriptionHeight), decriptionHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSNumber*)isMineChallenge{
    return objc_getAssociatedObject(self, @selector(isMineChallenge));
}

-(void)setIsMineChallenge:(NSNumber*)isMineChallenge{
    objc_setAssociatedObject(self, @selector(isMineChallenge), isMineChallenge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableAttributedString*)attributedDescription{
    return objc_getAssociatedObject(self, @selector(attributedDescription));
}
-(void)setAttributedDescription:(NSMutableAttributedString*)attributedDescription{
    objc_setAssociatedObject(self, @selector(attributedDescription), attributedDescription, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(YGSession*)currentWorkout{
    YGSession *workout = nil;
    if (self.workoutList.count) {
        int currentWorkoutIndex = 0;
        for (int i=0; i<self.workoutList.count;i++) {
            YGSession *workout = self.workoutList[i];
            if (workout.status.intValue<3) {
                currentWorkoutIndex = i;
                break;
            }
        }
        workout = self.workoutList[currentWorkoutIndex];
    }
    return workout;
}
@end
