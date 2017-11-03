//
//  UINavigationBar+Extension.m
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "objc/runtime.h"
#import "UINavigationBar+Extension.h"

static char const *const heightKey = "Height";

@implementation UINavigationBar (Extension)

- (NSNumber *)height{
    return objc_getAssociatedObject(self, heightKey);
}

- (void)setHeight:(NSNumber*)height{
    objc_setAssociatedObject(self, heightKey, height, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize newSize;
    if (self.height) {
        newSize = CGSizeMake(self.superview.bounds.size.width, [self.height floatValue]);
    } else {
        newSize = [super sizeThatFits:size];
    }
    return newSize;
}
@end
