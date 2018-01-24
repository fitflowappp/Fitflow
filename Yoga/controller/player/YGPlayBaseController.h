//
//  YGPlayBaseController.h
//  Yoga
//
//  Created by lyj on 2017/9/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGPlayer.h"
#import "YGBaseController.h"

@interface YGPlayBaseController : YGBaseController<YGPlayerDelegate>
-(void)playBackgroundMusic;
-(void)pauseBackgroundMusic;
-(void)setBackGroundMusicVolume:(float)volume;
-(void)playBackgroundMusicItemIndex:(NSInteger)index;
@end
