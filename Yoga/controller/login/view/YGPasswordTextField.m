//
//  YGPasswordTextField.m
//  Yoga
//
//  Created by lyj on 2017/12/20.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGPasswordTextField.h"

@implementation YGPasswordTextField

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.keyboardType = UIKeyboardTypeASCIICapable;
        [self addEyeBtn];
    }
    return self;
}

-(void)addEyeBtn{
    UIButton *eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    eyeBtn.frame = [self leftViewRectForBounds:self.bounds];
    eyeBtn.adjustsImageWhenHighlighted = NO;
    [eyeBtn setImage:[UIImage imageNamed:@"password-eye-close"] forState:UIControlStateNormal];
    [eyeBtn setImage:[UIImage imageNamed:@"password-eye_open"] forState:UIControlStateSelected];
    [eyeBtn addTarget:self action:@selector(passwordEyeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.leftView = eyeBtn;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    CGFloat marginX = (24/375.0)*GET_SCREEN_WIDTH;
    CGRect rect = CGRectMake(marginX,0,(243/375.0)*GET_SCREEN_WIDTH+12-marginX*2,bounds.size.height);
    return rect;
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGFloat marginX = (24/375.0)*GET_SCREEN_WIDTH;
    CGRect rect = CGRectMake(marginX,0,self.frame.size.width-marginX*2,bounds.size.height);
    return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGFloat marginX = (24/375.0)*GET_SCREEN_WIDTH;
    CGRect rect = CGRectMake(marginX,0,(243/375.0)*GET_SCREEN_WIDTH+12-marginX*2,bounds.size.height);
    return rect;
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds{
    CGRect rect = CGRectMake((243/375.0)*GET_SCREEN_WIDTH,(bounds.size.height-12)/2,12,12);
    return rect;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGFloat marginX = (243/375.0)*GET_SCREEN_WIDTH+12;
    CGRect rect = CGRectMake(marginX,0,bounds.size.width-marginX,bounds.size.height);
    return rect;
}

-(void)passwordEyeBtnClicked:(UIButton*)sender{
    BOOL unSecureEntry = !sender.selected;
    if (unSecureEntry==YES) {
        self.secureTextEntry = NO;
    }else{
        self.secureTextEntry = YES;
    }
    sender.selected = unSecureEntry;
}
@end
