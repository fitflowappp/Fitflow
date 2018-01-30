//
//  ViewController.h
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGBaseController : UIViewController
@property (nonatomic) CGFloat scale;
-(void)setLeftNavigationItem;
-(void)retryWhenNetworkError;
-(void)setRightShareNavigationItem;
-(void)shareWithContent:(NSArray*)content;
- (void)didSelectShareCompleted;
- (void)back;
@end

