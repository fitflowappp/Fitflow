//
//  YGHomeNoSinglesCell.m
//  Yoga
//
//  Created by lyj on 2018/1/5.
//  Copyright © 2018年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGHomeNoSinglesCell.h"
@interface YGHomeNoSinglesCell ()
@property (nonatomic,strong) UILabel *noSinglesTipLabel;
@end
@implementation YGHomeNoSinglesCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setHomeNoSinglesCell];
    }
    return self;
}

-(void)setHomeNoSinglesCell{
    self.backgroundColor = [UIColor whiteColor];
    self.noSinglesTipLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.noSinglesTipLabel.textAlignment = NSTextAlignmentCenter;
    self.noSinglesTipLabel.text = @"You have no Singles saved.";
    self.noSinglesTipLabel.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
    self.noSinglesTipLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    [self addSubview:self.noSinglesTipLabel];
}
@end
