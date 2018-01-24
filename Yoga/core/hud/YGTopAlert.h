//
//  YGTopAlert.h
//  Yoga
//
//  Created by lyj on 2017/12/25.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGTopAlert : UIView
@property (nonatomic,strong) UILabel     *alertLabel;
+(YGTopAlert*)alert:(NSString*)msg bkColorCode:(NSString*)code;
@end
