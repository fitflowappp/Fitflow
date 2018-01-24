//
//  YGPlayController.h
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGSession+Extension.h"
#import "YGPlayBaseController.h"
@interface YGPlayController : YGPlayBaseController
@property (nonatomic,strong) YGSession    *session;
@property (nonatomic,strong) NSString *challengeID;
@end
