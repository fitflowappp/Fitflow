//
//  YGTextHeader.m
//  Yoga
//
//  Created by 小黑胖 on 2017/9/14.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGTextHeader.h"
@interface YGTextHeader ()
@property (nonatomic,strong) UILabel *textLabel;
@end
@implementation YGTextHeader
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setTextLabel];
    }
    return self;
}

-(void)setTextLabel{
    self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.textLabel.numberOfLines = 0;
    [self addSubview:self.textLabel];
}

-(void)setText:(NSMutableAttributedString *)text{
    if (text!=_text) {
        _text = text;
        self.textLabel.attributedText = text;
    }
    self.textLabel.frame = self.bounds;
}

@end
