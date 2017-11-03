//
//  YGBaseAlert.m
//  Yoga
//
//  Created by lyj on 2017/10/23.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGBaseAlert.h"

@implementation YGBaseAlert

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        hideTap.delegate = self;
        [self addGestureRecognizer:hideTap];
    }
    return self;
}

-(void)hide{
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view==self) {
        return YES;
    }
    return NO;
}
@end
