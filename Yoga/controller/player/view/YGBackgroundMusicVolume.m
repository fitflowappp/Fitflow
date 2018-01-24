//
//  YGBackgroundMusicVolume.m
//  Yoga
//
//  Created by lyj on 2018/1/16.
//  Copyright © 2018年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "UIImage+Extension.h"
#import "YGBackgroundMusicVolume.h"

@implementation YGBackgroundMusicVolume
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.minimumValue = 0;
        self.maximumValue = 1.0;
        self.maximumTrackTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return self;
}

- (CGRect)trackRectForBounds:(CGRect)bounds{
    return CGRectMake(0,4, CGRectGetWidth(self.frame),4);
}

-(void)setLight:(BOOL)light{
    if (light==YES) {
        [self setThumbImage:[UIImage imageNamed:@"Play-background-music-thum-c"] forState:UIControlStateNormal];
        self.minimumTrackTintColor=[UIColor colorWithHexString:@"#0EC07F"];
    }else{
        [self setThumbImage:[UIImage imageNamed:@"Play-background-music-thum"] forState:UIControlStateNormal];
        self.minimumTrackTintColor=[UIColor colorWithHexString:@"#CCCCCC"];
    }
}
@end
