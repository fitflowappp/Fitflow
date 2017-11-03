//
//  YGChallengeSessionCell.h
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGSession.h"
typedef NS_ENUM(NSInteger,WORKOUT_INDEX_TYPE){
    WORKOUT_INDEX_TOP ,
    WORKOUT_INDEX_CENTER,
    WORKOUT_INDEX_BOTTOM,
    WORKOUT_INDEX_ONLY_ONE,
};
@interface YGWorkoutCell : UICollectionViewCell

@property (nonatomic) BOOL isMineChallengeWorkout;

@property (nonatomic,strong) YGSession *workout;

@property (nonatomic,assign) NSInteger workoutIndex;

@property (nonatomic) WORKOUT_INDEX_TYPE workoutIndexType;

@end
