//
//  YGHUD.m
//  Yoga
//
//  Created by lyj on 2017/9/21.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGHUD.h"
#import "UIColor+Extension.h"
@implementation YGHUD
+(MBProgressHUD*)loading:(UIView*)v{
    [YGHUD hide:v];
    MBProgressHUD* hud= [MBProgressHUD showHUDAddedTo:v animated:YES];
    hud.backgroundColor=[UIColor clearColor];
    hud.color = [UIColor clearColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    UIImageView *loadingImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading-01"]];
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1;i<9;i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"loading-%0.2d",i]];
        [images addObject:img];
    }
    loadingImgv.contentMode = UIViewContentModeScaleAspectFill;
    loadingImgv.animationImages = images;
    loadingImgv.animationRepeatCount = (int)MAXFLOAT;
    loadingImgv.animationDuration = 0.8;
    hud.customView = loadingImgv;
    [loadingImgv startAnimating];
    hud.yOffset = -NAV_HEIGHT;
    return hud;
}

+(MBProgressHUD*)alertMsg:(NSString*)msg at:(UIView*)v{
    [YGHUD hide:v];
    MBProgressHUD* hud= [MBProgressHUD showHUDAddedTo:v animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,300,300)];
    customView.backgroundColor = [UIColor clearColor];
    UILabel *errorLabel = [[UILabel alloc] initWithFrame:customView.bounds];
    errorLabel.text = msg;
    errorLabel.numberOfLines = 0;
    errorLabel.textAlignment = NSTextAlignmentCenter;
    errorLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    errorLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16*SCALE];
    [errorLabel sizeToFit];
    customView.bounds = errorLabel.bounds;
    [customView addSubview:errorLabel];
    hud.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    hud.customView = customView;
    hud.margin = 10;
    hud.square = YES;
    hud.yOffset = -NAV_HEIGHT;
    [hud hide:YES afterDelay:3];
    return hud;
}

+(MBProgressHUD*)alertNetworkErrorIn:(UIView*)v{
    return [YGHUD alertNetworkErrorIn:v target:nil];
}

+(MBProgressHUD*)alertNetworkErrorIn:(UIView*)v target:(id)target{
    [YGHUD hide:v];
    MBProgressHUD* hud= [MBProgressHUD showHUDAddedTo:v animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    UIImageView *errorImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Netowrk error"]];
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,errorImgv.frame.size.width+100,200)];
    customView.backgroundColor = [UIColor clearColor];
    errorImgv.center = CGPointMake(customView.frame.size.width/2,errorImgv.frame.size.height/2);
    [customView addSubview:errorImgv];
    UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,errorImgv.frame.size.height,customView.frame.size.width,19*SCALE)];
    errorLabel.text = @"Network load error";
    errorLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    errorLabel.textAlignment = NSTextAlignmentCenter;
    errorLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16*SCALE];
    [customView addSubview:errorLabel];
    UIButton *retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    retryBtn.frame = CGRectMake(0,0,72*SCALE,32*SCALE);
    retryBtn.layer.masksToBounds = YES;
    retryBtn.layer.cornerRadius = retryBtn.layer.frame.size.height/2;
    retryBtn.layer.borderWidth = 2.0;
    retryBtn.layer.borderColor = [UIColor colorWithHexString:@"#41D395"].CGColor;
    [retryBtn setTitle:@"RETRY" forState:UIControlStateNormal];
    [retryBtn setTitleColor:[UIColor colorWithHexString:@"#41D395"] forState:UIControlStateNormal];
    [retryBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Semibold" size:12*SCALE]];
    retryBtn.center = CGPointMake(errorLabel.center.x,CGRectGetMaxY(errorLabel.frame)+16*SCALE+retryBtn.frame.size.height/2);
    [retryBtn addTarget:target action:@selector(retryWhenNetworkError) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:retryBtn];
    CGRect rect = customView.frame;
    rect.size.height = CGRectGetMaxY(retryBtn.frame);
    customView.frame = rect;
    hud.margin = 0;
    hud.backgroundColor=[UIColor whiteColor];
    hud.color = [UIColor clearColor];
    hud.customView = customView;
    hud.yOffset = -NAV_HEIGHT;
    return hud;
}

+(void)hide:(UIView*)v{
    [MBProgressHUD hideHUDForView:v animated:YES];
    
}

-(void)retryWhenNetworkError{
    
}
@end
