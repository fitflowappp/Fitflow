//
//  RDDeviceUtil.h
//  Reading
//
//  Created by lyj on 17/8/24.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGDeviceUtil : NSObject
+(BOOL)updated;
+(NSString*)version;
+(BOOL)firstInstallFitflow;
+(BOOL)hasEnteredSinglesInDiscover;
+(BOOL)hasEnteredChallengesInDiscover;
+(BOOL)hasEnteredScheduling;
@end
