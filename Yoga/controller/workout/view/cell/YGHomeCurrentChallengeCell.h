//
//  YGHomeCurrentChallengeCell.h
//  Yoga
//
//  Created by lyj on 2018/1/3.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGChallenge+Extension.h"
@protocol  YGHomeCurrentChallengeCellDelegate<NSObject>
-(void)didSelectPlayCurrentWorkout:(YGSession*)workout;
@end
@interface YGHomeCurrentChallengeCell : UICollectionViewCell
@property (nonatomic,strong) YGChallenge *challenge;
@property (nonatomic,weak) id<YGHomeCurrentChallengeCellDelegate> delegate;
@end
