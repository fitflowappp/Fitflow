//
//  UIImage+Extension.h
//  Reading
//
//  Created by lyj on 17/8/18.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>
@interface UIImage (Extension)
+ (UIImage*)imageWithColor:(UIColor*)color;
- (UIImage*)boxblurImageWithBlur:(CGFloat)blur;
- (UIImage*)subImgageInRect:(CGRect)rect;
@end
