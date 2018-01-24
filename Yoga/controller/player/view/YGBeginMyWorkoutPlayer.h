//
//  YGBeginMyWorkoutPlayer.h
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YGBeginMyWorkoutPlayerDelegate <NSObject>
-(void)login;
-(void)beginMyWorkout;
@end
@interface YGBeginMyWorkoutPlayer : UIView
@property (nonatomic,weak) id<YGBeginMyWorkoutPlayerDelegate> delegate;
@end
