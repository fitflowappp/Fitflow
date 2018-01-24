//
//  YGSessionBannerCell.h
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGSession.h"
@protocol YGSessionBannerCellDelegate<NSObject>
-(void)handleFavorate:(BOOL)favorate;
@end
@interface YGSessionBannerCell : UICollectionViewCell
//@property (nonatomic) BOOL shouldLight;
@property (nonatomic) BOOL shouldFavorate;
@property (nonatomic,strong) YGSession *session;
@property (nonatomic,weak) id<YGSessionBannerCellDelegate> delegate;
@end
