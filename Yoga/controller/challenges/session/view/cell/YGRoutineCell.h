//
//  YogaRoutineCell.h
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGRoutine.h"
typedef NS_ENUM(NSInteger,ROUTINE_INDEX_TYPE){
    ROUTINE_INDEX_TOP ,
    ROUTINE_INDEX_CENTER,
    ROUTINE_INDEX_BOTTOM,
    ROUTINE_INDEX_ONLY_ONE,
};
@interface YGRoutineCell : UICollectionViewCell
@property (nonatomic,strong) YGRoutine *routine;
@property (nonatomic) NSInteger routineIndex;
@property (nonatomic) ROUTINE_INDEX_TYPE routineIndexType;
@end
