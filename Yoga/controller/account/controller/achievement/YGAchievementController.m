//
//  YGAchievementController.m
//  Yoga
//
//  Created by lyj on 2017/10/11.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGTextHeader.h"
#import "YGRefreshHeader.h"
#import "UIColor+Extension.h"
#import "YGUserNetworkService.h"
#import "YGAchievementNumberCell.h"
#import "YGAchievementController.h"
static NSString *ACHIEVEMENT_NUMBER_CELLID = @"achievementNumberCellID";
static NSString *ACHIEVEMENT_TEXT_HEADERID = @"achievementTextHeaderID";
@interface YGAchievementController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *achievementList;
@end

@implementation YGAchievementController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItem];
    [self setCollectionView];
    [self.navigationItem setTitle:@"Achievements"];
    self.achievementList = [NSMutableArray array];
    [YGHUD loading:self.view];
    [self fetchAchimentInfo];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)fetchAchimentInfo{
    __weak typeof(self) ws = self;
    [[YGUserNetworkService instance] fetchUserAchievementSucessBlock:^(NSMutableArray* achievementList) {
        [YGHUD hide:ws.view];
        if (achievementList.count) {
            ws.achievementList = achievementList;
            [ws.collectionView reloadData];
        }
        [ws.collectionView.mj_header endRefreshing];
        
    } failureBlcok:^(NSError *error) {
        [YGHUD hide:ws.view];
        [ws.collectionView.mj_header endRefreshing];
        if (ws.achievementList.count) {
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
        }else{
            [YGHUD alertNetworkErrorIn:ws.view target:ws];
        }
    }];
}

-(void)retryWhenNetworkError{
    [YGHUD loading:self.view];
    [self fetchAchimentInfo];
}

#pragma mark UI
-(void)setCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 8;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,GET_SCREEN_WIDTH, GET_SCREEN_HEIGHT-NAV_HEIGHT) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(24,0,0,0);
    [self.collectionView registerClass:[YGAchievementNumberCell class] forCellWithReuseIdentifier:ACHIEVEMENT_NUMBER_CELLID];
    [self.collectionView registerClass:[YGTextHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ACHIEVEMENT_TEXT_HEADERID];
    self.collectionView.mj_header = [YGRefreshHeader headerAtTarget:self action:@selector(fetchAchimentInfo) view: self.collectionView];
    [self.view addSubview:self.collectionView];
}

#pragma mark UICollectionView-Datasouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.achievementList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSString *number = self.achievementList[section];
    return number.length;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YGAchievementNumberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ACHIEVEMENT_NUMBER_CELLID forIndexPath:indexPath];
    NSString *number = self.achievementList[indexPath.section];
    cell.number = [number substringWithRange:NSMakeRange(indexPath.row,1)];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    YGTextHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ACHIEVEMENT_TEXT_HEADERID forIndexPath:indexPath];
    NSString *headerText = nil;
    if (indexPath.section==0) {
        headerText = @"CLASSES\nCOMPLETED";
    }else if (indexPath.section==1){
        headerText = @"MINUTES\nCOMPLETED";
    }else if (indexPath.section==2){
        headerText = @"MEMBERSHIP\nDAYS";
    }
    if (headerText) {
        NSMutableAttributedString *aHeaderText = [[NSMutableAttributedString alloc] initWithString:headerText];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:[UIFont fontWithName:@"Lato-Regular" size:12] forKey:NSFontAttributeName];
        [params setObject:[UIColor colorWithHexString:@"#9B9B9B"]forKey:NSForegroundColorAttributeName];
        [params setObject:style forKey:NSParagraphStyleAttributeName];
        [aHeaderText addAttributes:params range:NSMakeRange(0,aHeaderText.length)];
        header.text = aHeaderText;
    }
    
    return header;
}

#pragma mark UICollectionView-Layout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    NSInteger count = [self collectionView:collectionView numberOfItemsInSection:section];
    CGFloat margin = (GET_SCREEN_WIDTH-count*44*self.scale-(count-1)*8)/2;
    
    return UIEdgeInsetsMake(16*self.scale,margin,48*self.scale,0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake(44*self.scale,64*self.scale);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.frame.size.width,30);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
