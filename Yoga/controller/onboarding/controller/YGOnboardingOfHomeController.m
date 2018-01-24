//
//  YGOnboardingOfHomeController.m
//  Yoga
//
//  Created by lyj on 2017/12/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGStringUtil.h"
#import "YGNetworkService.h"
#import "UIColor+Extension.h"
#import "YGOnboardingGoalCell.h"
#import "YGOnboardingOfHomeController.h"
#import "YGOnboardingOfNotificationController.h"
#import "YGOnboardingOfRecommendationController.h"
@interface YGOnboardingOfHomeController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UIButton *skipBtn;
@property (nonatomic,strong) UILabel  *subTitleLabel;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *recommendTopicChallengeList;
@end

@implementation YGOnboardingOfHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
}

-(void)setUpSubviews{
    [super setUpSubviews];
    [self addTitleLabelWithText:@"CHOOSE YOUR\nGOAL"];
    [self.backGroundImgv setImage:[UIImage imageNamed:@"onboarding1.jpg"]];
    [self addSubTitleLabel];
    [self addSkipBtn];
    [self addCollectionView];
    self.backBtn.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setOnboardingStep:1];
    [self fetchRecommendTopicChallengeList];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)fetchRecommendTopicChallengeList{
    if (self.recommendTopicChallengeList.count==0) {
        MBProgressHUD *hud =  [YGHUD loading:self.collectionView];
        hud.yOffset = -(self.collectionView.frame.size.height-64*SCALE*4)/2;
        [[YGNetworkService instance] networkWithUrl:URLForge(@"/yoga/challenge/getTopical") requsetType:GET successBlock:^(id data) {
            if ([YGStringUtil notNull:data]) {
                self.recommendTopicChallengeList = data;
                [self.collectionView reloadData];
            }
            [YGHUD hide:self.collectionView];
        } errorBlock:^(NSError *error) {
            [YGHUD hide:self.view];
            [YGHUD alertNetworkErrorIn:self.view target:self];
        }];
    }
}

-(void)retryWhenNetworkError{
    [YGHUD loading:self.collectionView];
    [self fetchRecommendTopicChallengeList];
}

-(void)addSubTitleLabel{
    CGFloat marginX = (56/375.0)*self.view.frame.size.width;
    CGFloat marginY = CGRectGetMaxY(self.titleLabel.frame)+12*SCALE;
    CGFloat width   = self.view.frame.size.width-marginX*2;
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX,marginY,width,18)];
    self.subTitleLabel.text = @"Try yoga for...";
    self.subTitleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.subTitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    [self.view addSubview:self.subTitleLabel];
}

-(void)addSkipBtn{
    CGFloat marginY = (IS_IPHONE_X?72:32*SCALE)-10;
    CGFloat marginRight = IS_IPHONE_X?32:32*SCALE;
    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipBtn.frame = CGRectMake(self.view.frame.size.width-marginRight-70,marginY,70,16*SCALE+20);
    [self.skipBtn setTitle:@"Skip" forState:UIControlStateNormal];
    [self.skipBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.skipBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
    [self.skipBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.skipBtn addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.skipBtn];
}

-(void)addCollectionView{
    CGFloat marginX = (56/375.0)*self.view.frame.size.width;
    CGFloat marginY = CGRectGetMaxY(self.subTitleLabel.frame)+32*SCALE;
    CGFloat width   = self.view.frame.size.width-marginX*2;
    CGFloat height  = self.view.frame.size.height- marginY -100*SCALE;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(marginX,marginY,width,height) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[YGOnboardingGoalCell class] forCellWithReuseIdentifier:@"goalCellID"];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.recommendTopicChallengeList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YGOnboardingGoalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goalCellID" forIndexPath:indexPath];
    NSDictionary *dictionary = self.recommendTopicChallengeList[indexPath.row];
    cell.titlabel.text = [dictionary objectForKey:@"title"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.width,64*SCALE);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YGOnboardingOfRecommendationController *controller = [[YGOnboardingOfRecommendationController alloc] init];
    NSDictionary *dictionary = self.recommendTopicChallengeList[indexPath.row];
    controller.topicChallengeID = [dictionary objectForKey:@"challengeId"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)skip{
    YGOnboardingOfNotificationController *controller = [[YGOnboardingOfNotificationController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
