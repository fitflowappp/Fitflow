//
//  YGSingleCell.h
//  Yoga
//
//  Created by lyj on 2018/1/3.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGSession.h"
@protocol YGSingleCellDelegate<NSObject>
-(void)playWorkoutInSingle:(YGSession*)workout;
@end
@interface YGSingleCell : UICollectionViewCell
@property (nonatomic,strong) YGSession *workout;
@property (nonatomic,weak) id<YGSingleCellDelegate> delegate;
@end
