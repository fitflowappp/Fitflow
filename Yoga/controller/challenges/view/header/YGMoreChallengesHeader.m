//
//  YGMoreChallengesHeader.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGMoreChallengesHeader.h"

@implementation YGMoreChallengesHeader
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setMoreChallengesHeader];
    }
    return self;
}

-(void)setMoreChallengesHeader{
    [self addGrayTipLabel];
    [self addBlackTipLabel];
    [self setBackgroundColor:[UIColor clearColor]];
}

-(void)addGrayTipLabel{
    CGFloat centerY = self.frame.size.height/2;
    UILabel *grayTipLabel = [[UILabel alloc] init];
    grayTipLabel.textAlignment = NSTextAlignmentCenter;
    grayTipLabel.text = @"Finish first challenge to unlock";
    grayTipLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    grayTipLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12*SCALE];
    grayTipLabel.frame = CGRectMake(0,centerY+4*SCALE+3,self.frame.size.width,15*SCALE);
    [self addSubview:grayTipLabel];
    
}

-(void)addBlackTipLabel{
    CGFloat centerY = self.frame.size.height/2;
    UILabel *blackTipLabel = [[UILabel alloc] init];
    blackTipLabel.text = @"- MORE CHALLENGES -";
    blackTipLabel.textColor = [UIColor blackColor];
    blackTipLabel.textAlignment = NSTextAlignmentCenter;
    blackTipLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12*SCALE];
    blackTipLabel.frame = CGRectMake(0,centerY-4*SCALE-15*SCALE+3,self.frame.size.width,15*SCALE);
    [self addSubview:blackTipLabel];
}
@end
