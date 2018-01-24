//
//  YGSchedulingEntranceCell.m
//  Yoga
//
//  Created by lyj on 2017/10/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGSchedulingEntranceCell.h"
@interface YGSchedulingEntranceCell ()
@property (nonatomic,strong) UIView      *linev;
@property (nonatomic,strong) UIImageView *arrowImgv;
@property (nonatomic,strong) UILabel     *titleLabel;
@property (nonatomic,strong) UILabel     *subtitleLabel;
@end


@implementation YGSchedulingEntranceCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setShedulingEntranceCell];
    }
    return self;
}

-(void)setShedulingEntranceCell{
    self.backgroundColor = [UIColor whiteColor];
    [self addLinev];
    [self addArrowImgv];
    [self addSubtitleLabel];
    [self addTitleLabel];
}

-(void)addLinev{
    self.linev = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-1,self.frame.size.width,1)];
    self.linev.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    [self addSubview:self.linev];
    
}

-(void)addArrowImgv{
    self.arrowImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
    self.arrowImgv.center = CGPointMake(self.frame.size.width-self.arrowImgv.frame.size.width/2,(self.frame.size.height-1)/2);
    [self addSubview:self.arrowImgv];
}


-(void)addTitleLabel{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(0,0,self.subtitleLabel.frame.origin.x-10,self.frame.size.height-1);
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    [self addSubview:self.titleLabel];
}

-(void)addSubtitleLabel{
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.frame = CGRectMake(self.arrowImgv.frame.origin.x-16-70,0,70,self.frame.size.height-1);
    self.subtitleLabel.textAlignment = NSTextAlignmentRight;
    self.subtitleLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    self.subtitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    [self addSubview:self.subtitleLabel];
}

-(void)setTitleText:(NSString *)titleText{
    if (titleText!=_titleText) {
        _titleText = titleText;
        self.titleLabel.text = titleText;
    }
}

-(void)setSubTitleText:(NSString *)subTitleText{
    if (subTitleText!=_subTitleText) {
        _subTitleText = subTitleText;
        self.subtitleLabel.text = subTitleText;
    }


}

@end
