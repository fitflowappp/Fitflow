//
//  YGWorkoutScheduleView.m
//  Yoga
//
//  Created by lyj on 2017/10/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "UIColor+Extension.h"
#import "YGWorkoutScheduleView.h"
#import "YGWorkoutScheduleCell.h"
static NSString *WORKOUT_SCHEDULE_CELLID = @"workoutSheduleCellID";
@interface YGWorkoutScheduleView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UILabel  *titleLabel;
@property (nonatomic,strong) UIButton *hideBtn;
@property (nonatomic,strong) NSArray  *scheduleList;
@property (nonatomic,strong) UICollectionView *scheduleCollectionView;
@end
@implementation YGWorkoutScheduleView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.scheduleList = @[@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT",@"SUN"];
        [self setWorkoutScheduleView];
    }
    return self;
}

-(void)setWorkoutScheduleView{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.alpha = 0;
    /**/
    [self addScheduleCollectionView];
    [self addTitleLabel];
    [self addCancelBtn];
    [self addSureBtn];
    [self addHideBtn];
    [self show];
}

-(void)addTitleLabel{
    CGFloat scale = SCALE;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.scheduleCollectionView.frame.origin.y-48*scale,self.frame.size.width,48*scale)];
    self.titleLabel.text = @"Set your workout schedule";
    self.titleLabel.userInteractionEnabled = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16*scale];
    [self addSubview:self.titleLabel];
}

-(void)addCancelBtn{
    CGFloat scale = SCALE;
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(0,self.titleLabel.frame.origin.y,45*scale+32*scale,self.titleLabel.frame.size.height);
    [self.cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor colorWithHexString:@"#41D395"] forState:UIControlStateNormal];
    [self.cancelBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Semibold" size:14*scale]];
    [self.cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
}

-(void)addSureBtn{
    CGFloat scale = SCALE;
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureBtn.frame = CGRectMake(self.frame.size.width-32*scale-45*scale,self.titleLabel.frame.origin.y,45*scale+32*scale,self.titleLabel.frame.size.height);
    [self.sureBtn setTitle:@"Accept" forState:UIControlStateNormal];
    [self.sureBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Semibold" size:14*scale]];
    [self.sureBtn setTitleColor:[UIColor colorWithHexString:@"#41D395"] forState:UIControlStateNormal];
    [self addSubview:self.sureBtn];
}

-(void)addScheduleCollectionView{
    CGFloat scale = SCALE;
    CGFloat H = (32*2*scale+56*2*scale+16*scale);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 16*scale;
    layout.minimumInteritemSpacing = 24*scale;
    self.scheduleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,self.frame.size.height+48*SCALE,self.frame.size.width, H) collectionViewLayout:layout];
    self.scheduleCollectionView.delegate = self;
    self.scheduleCollectionView.dataSource = self;
    self.scheduleCollectionView.showsVerticalScrollIndicator = NO;
    self.scheduleCollectionView.backgroundColor = [UIColor whiteColor];
    [self.scheduleCollectionView registerClass:[YGWorkoutScheduleCell class] forCellWithReuseIdentifier:WORKOUT_SCHEDULE_CELLID];
    [self addSubview:self.scheduleCollectionView];
}

-(void)addHideBtn{
    self.hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hideBtn.backgroundColor = [UIColor clearColor];
    self.hideBtn.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height-self.scheduleCollectionView.frame.size.height-self.titleLabel.frame.size.height);
    [self.hideBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.hideBtn];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section==0?4:3;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YGWorkoutScheduleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WORKOUT_SCHEDULE_CELLID forIndexPath:indexPath];
    cell.scheduleTitle = self.scheduleList[indexPath.section*4+indexPath.row];
    if (indexPath.section*4+indexPath.row<self.scheduleStatusList.count) {
        NSNumber *status = self.scheduleStatusList[indexPath.section*4+indexPath.row];
        cell.shouldLigth = status.boolValue;
    }else{
        cell.shouldLigth = NO;
    }
    return cell;
}

#pragma mark UICollectionView-Layout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat scale = SCALE;
    
    if (section==0) {
        CGFloat margin = (collectionView.frame.size.width-4*56*scale-3*24*scale)/2;
        
        return UIEdgeInsetsMake(32*scale,margin,16*scale,margin);
    }
    CGFloat margin = (collectionView.frame.size.width-3*56*scale-2*24*scale)/2;
    return UIEdgeInsetsMake(0,margin,32*scale,margin);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat diamter = 56*SCALE;
    return CGSizeMake(diamter,diamter);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YGWorkoutScheduleCell *cell = (YGWorkoutScheduleCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section*4+indexPath.row<self.scheduleStatusList.count) {
        int remainScheduleDays = 0;
        for (NSNumber *status in self.scheduleStatusList) {
            if (status.boolValue==YES) {
                remainScheduleDays++;
            }
        }
        if (remainScheduleDays==1&&cell.shouldLigth==YES) {
            return;
        }
        cell.shouldLigth = !cell.shouldLigth;
        NSNumber *status = self.scheduleStatusList[indexPath.section*4+indexPath.row];
        if (cell.shouldLigth==YES) {
            status = @(1);
        }else{
            status = @(0);
        }
        [self.scheduleStatusList replaceObjectAtIndex:indexPath.section*4+indexPath.row withObject:status];
    }
    
}

-(void)setScheduleStatusList:(NSMutableArray *)scheduleStatusList{
    _scheduleStatusList = scheduleStatusList;
    [self.scheduleCollectionView reloadData];
    
}
-(void)hide{
    CGRect rect1 = self.scheduleCollectionView.frame;
    CGRect rect2 = self.titleLabel.frame;
    CGRect rect3 = self.cancelBtn.frame;
    CGRect rect4 = self.sureBtn.frame;
    rect1.origin.y = self.frame.size.height+rect1.size.height+rect2.size.height;
    rect2.origin.y = self.frame.size.height +rect2.size.height;
    rect3.origin.y = rect2.origin.y;
    rect4.origin.y = rect2.origin.y;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.scheduleCollectionView.frame = rect1;
        self.titleLabel.frame = rect2;
        self.cancelBtn.frame = rect3;
        self.sureBtn.frame = rect4;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.sureBtn removeFromSuperview];
        [self.cancelBtn removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.scheduleCollectionView removeFromSuperview];
        [self.hideBtn removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(void)show{
    CGRect rect1 = self.scheduleCollectionView.frame;
    CGRect rect2 = self.titleLabel.frame;
    CGRect rect3 = self.cancelBtn.frame;
    CGRect rect4 = self.sureBtn.frame;
    rect1.origin.y = self.frame.size.height-rect1.size.height;
    rect2.origin.y = self.frame.size.height - rect1.size.height-rect2.size.height;
    rect3.origin.y = rect2.origin.y;
    rect4.origin.y = rect2.origin.y;
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.scheduleCollectionView.frame = rect1;
        self.titleLabel.frame = rect2;
        self.cancelBtn.frame = rect3;
        self.sureBtn.frame = rect4;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
@end
