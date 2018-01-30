//
//  YGSessionCommand.h
//  Yoga
//
//  Created by lyj on 2017/9/19.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGNetworkBaseCommand.h"

@interface YGSessionCommand : YGNetworkBaseCommand
@property (nonatomic,strong) NSString *sessionID;
@property (nonatomic,strong) NSString *challengeID;
@property (nonatomic, strong) NSString *workoutID;
@property (nonatomic,copy) FAILURE_BLOCK actionErrorBlock;
@property (nonatomic,copy) SUCCESS_BLOCK actionsuccessBlock;
@end
