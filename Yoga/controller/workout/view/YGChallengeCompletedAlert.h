//
//  YGChallengeCompleteAletView.h
//  Yoga
//
//  Created by lyj on 2017/9/29.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGBaseAlert.h"
@interface YGChallengeCompletedAlert : YGBaseAlert
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UIButton *startNewChallengeBtn;
-(id)initWithFrame:(CGRect)frame challengeTittle:(NSString*)tittle;
@end
