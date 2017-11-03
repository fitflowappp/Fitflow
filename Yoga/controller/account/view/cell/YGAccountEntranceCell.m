//
//  YGAccountEntranceCell.m
//  Yoga
//
//  Created by lyj on 2017/9/18.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGAccountEntranceCell.h"

@interface YGAccountEntranceCell()
@property (nonatomic,strong) UIView *linev;
@property (nonatomic,strong) UIImageView *iconImgv;
@property (nonatomic,strong) UILabel     *titleLabel;
@property (nonatomic,strong) UIImageView *arrowImgv;
@end
@implementation YGAccountEntranceCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAccountEntranceCell];
    }
    return self;
}

-(void)setAccountEntranceCell{
    self.backgroundColor = [UIColor clearColor];
    _entranceIndex = -1;
    [self addLinev];
    [self addIconImgv];
    [self addArrowImgv];
    [self addTitleLabel];
}

-(void)addLinev{
    self.linev = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-1,self.frame.size.width,1)];
    self.linev.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    [self addSubview:self.linev];
}

-(void)addIconImgv{
    CGFloat scale = SCALE;
    self.iconImgv = [[UIImageView alloc] init];
    self.iconImgv.frame = CGRectMake(0,(self.frame.size.height-1-24*scale)/2,24*scale,24*scale);
    [self addSubview:self.iconImgv];
}

-(void)addArrowImgv{
    self.arrowImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
    self.arrowImgv.center = CGPointMake(self.frame.size.width-self.arrowImgv.frame.size.width,(self.frame.size.height-1)/2);
    [self addSubview:self.arrowImgv];
}

-(void)addTitleLabel{
    CGFloat scale = SCALE;
    CGFloat titleX = CGRectGetMaxX(self.iconImgv.frame)+8*scale;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(titleX,0,self.arrowImgv.frame.origin.x-titleX,self.frame.size.height-1);
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16*scale];
    [self addSubview:self.titleLabel];
}
-(void)setEntranceIndex:(NSInteger)entranceIndex{
    if (entranceIndex!=_entranceIndex) {
        _entranceIndex = entranceIndex;
        switch (entranceIndex) {
            case 0:
            {
                self.iconImgv.image = [UIImage imageNamed:@"Scheduling-gray"];
                self.titleLabel.text = @"Scheduling";
            }
                break;
            case 1:
            {
                self.iconImgv.image = [UIImage imageNamed:@"Achievements-gray"];
                self.titleLabel.text = @"Achievements";
            }
                break;
            case 2:
            {
                self.iconImgv.image = [UIImage imageNamed:@"Aboutus-gray"];
                self.titleLabel.text = @"About Us";
            }
                break;
                
            default:
                break;
        }
    }
}
@end
