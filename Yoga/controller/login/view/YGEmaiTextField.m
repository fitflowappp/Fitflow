//
//  YGEmaiTextField.m
//  Yoga
//
//  Created by lyj on 2017/12/20.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGEmaiTextField.h"

@implementation YGEmaiTextField

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.keyboardType = UIKeyboardTypeEmailAddress;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return self;
}
- (CGRect)textRectForBounds:(CGRect)bounds{
    CGFloat marginX = (24/375.0)*GET_SCREEN_WIDTH;
    CGRect rect = CGRectMake(marginX,0,bounds.size.width-marginX*2,bounds.size.height);
    return rect;
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGFloat marginX = (24/375.0)*GET_SCREEN_WIDTH;
    CGRect rect = CGRectMake(marginX,0,bounds.size.width-marginX*2,bounds.size.height);
    return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGFloat marginX = (24/375.0)*GET_SCREEN_WIDTH;
    CGRect rect = CGRectMake(marginX,0,bounds.size.width-marginX*2,bounds.size.height);
    return rect;
}
@end
