//
//  YGAccountLoginFooter.h
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YGAccountLoginFooter : UICollectionReusableView
@property (nonatomic,strong) UIButton *loginBtn;
-(void)setRegisterStatus:(BOOL)unRegister;
@end
