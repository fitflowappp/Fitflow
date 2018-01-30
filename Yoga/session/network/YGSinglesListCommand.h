//
//  YGSinglesListCommand.h
//  Yoga
//
//  Created by lyj on 2018/1/3.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGNetworkBaseCommand.h"

@interface YGSinglesListCommand : YGNetworkBaseCommand
@property (nonatomic,copy) FAILURE_BLOCK lockerrorBlock;
@property (nonatomic,copy) SUCCESS_BLOCK locksuccessBlock;
@property (nonatomic,copy) FAILURE_BLOCK unlockerrorBlock;
@property (nonatomic,copy) SUCCESS_BLOCK unlocksuccessBlock;
@end
