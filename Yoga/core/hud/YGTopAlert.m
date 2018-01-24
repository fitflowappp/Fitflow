//
//  YGTopAlert.m
//  Yoga
//
//  Created by lyj on 2017/12/25.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGTopAlert.h"
#import "UIColor+Extension.h"
@interface YGTopAlert ()
@property (nonatomic,strong) UIImageView *alertImgv;
@end
@implementation YGTopAlert

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addAlertImgv];
        [self addAlertLabel];
    }
    return self;
}

-(void)addAlertImgv{
    self.alertImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error-top-logo"]];
    self.alertImgv.center = CGPointMake(16+self.alertImgv.frame.size.width/2,29+20);
    [self addSubview:self.alertImgv];
}

-(void)addAlertLabel{
    CGFloat marginX = CGRectGetMaxX(self.alertImgv.frame)+16;
    self.alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX,20,self.frame.size.width-marginX-16,self.frame.size.height-20)];
    self.alertLabel.numberOfLines = 0;
    self.alertLabel.textColor = [UIColor whiteColor];
    self.alertLabel.backgroundColor = [UIColor clearColor];
    self.alertLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    [self addSubview:self.alertLabel];
}

+(YGTopAlert*)alert:(NSString*)msg bkColorCode:(NSString*)code{
    YGTopAlert *alert = [[YGTopAlert alloc] initWithFrame:CGRectMake(0,-58-20,GET_SCREEN_WIDTH,58+20)];
    alert.backgroundColor = [UIColor colorWithHexString:code];
    alert.alertLabel.text = msg;
    UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
    for (UIView *v in mainWindow.subviews) {
        if ([v isKindOfClass:[YGTopAlert class]]) {
            [v removeFromSuperview];
        }
    }
    [mainWindow addSubview:alert];
    [alert show];
    return alert;
}

-(void)show{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:20 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.frame = CGRectMake(0,0,GET_SCREEN_WIDTH,58+20);
    } completion:^(BOOL finished) {
        [self hide];
    }];
}

-(void)hide{
    [UIView animateWithDuration:0.5 delay:3 usingSpringWithDamping:1 initialSpringVelocity:20 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.frame = CGRectMake(0,-58-20,GET_SCREEN_WIDTH,58+20);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
