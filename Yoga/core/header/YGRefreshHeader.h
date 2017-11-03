//
//  YGRefreshHeader.h
//  Yoga
//
//  Created by lyj on 2017/9/21.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface YGRefreshHeader : MJRefreshGifHeader
+(YGRefreshHeader*)headerAtTarget:(id) target action:(SEL)action view:(UIScrollView *)scrollView;
@end
