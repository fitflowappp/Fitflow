//
//  YGHUD.h
//  Yoga
//
//  Created by lyj on 2017/9/21.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface YGHUD : MBProgressHUD
+(void)hide:(UIView*)v;

+(MBProgressHUD*)loading:(UIView*)v;

+(MBProgressHUD*)alertMsg:(NSString*)msg at:(UIView*)v;

+(MBProgressHUD*)alertNetworkErrorIn:(UIView*)v;

+(MBProgressHUD*)alertNetworkErrorIn:(UIView*)v target:(id)target;

@end
