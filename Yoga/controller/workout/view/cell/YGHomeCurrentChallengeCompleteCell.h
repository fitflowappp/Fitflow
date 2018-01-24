//
//  YGHomeCurrentChallengeCompleteCell.h
//  Yoga
//
//  Created by lyj on 2018/1/10.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGChallenge+Extension.h"
@protocol  YGHomeCurrentChallengeCellCompleteDelegate<NSObject>
-(void)didSelectChooseNewChallangeInHomeCompleteChallengeCell;
@end
@interface YGHomeCurrentChallengeCompleteCell : UICollectionViewCell
@property (nonatomic,strong) YGChallenge *challenge;
@property (nonatomic,weak) id<YGHomeCurrentChallengeCellCompleteDelegate> delegate;
@end
