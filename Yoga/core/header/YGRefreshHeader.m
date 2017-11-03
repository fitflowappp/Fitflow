//
//  YGRefreshHeader.m
//  Yoga
//
//  Created by lyj on 2017/9/21.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGRefreshHeader.h"

@implementation YGRefreshHeader
+(YGRefreshHeader*)headerAtTarget:(id) target action:(SEL)action view:(UIScrollView *)scrollView{
    YGRefreshHeader *refreshHeader = (YGRefreshHeader*)[MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    //闲置状态
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1;i<9;i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"loading-%0.2d",i]];
        [images addObject:img];
    }
    [refreshHeader setImages:images forState:MJRefreshStateIdle];
    [refreshHeader setImages:images forState:MJRefreshStatePulling];
    [refreshHeader setImages:images forState:MJRefreshStateRefreshing];
    [refreshHeader setImages:images forState:MJRefreshStateWillRefresh];
    [refreshHeader setImages:images forState:MJRefreshStateNoMoreData];
    refreshHeader.ignoredScrollViewContentInsetTop = scrollView.contentInset.top;
    scrollView.mj_header = refreshHeader;
    return refreshHeader;
}

@end
