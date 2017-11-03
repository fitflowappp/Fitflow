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



@end
