//
//  YGOnboardingOfRecommendationController.m
//  Yoga
//
//  Created by lyj on 2017/12/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGChallenge.h"
#import "YGStringUtil.h"
#import "YGStringUtil.h"
#import "UIColor+Extension.h"
#import "YGChallengeService.h"
#import "YGOnboardingOfNotificationController.h"
#import "YGOnboardingOfRecommendationController.h"
@interface YGOnboardingOfRecommendationController ()
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UILabel *challengeTitleLabel;
@property (nonatomic,strong) UILabel *challengeWeekTimeLabel;
@property (nonatomic,strong) UILabel *challengeDescriptionLabel;
@property (nonatomic,strong) UIButton *startedBtn;
@property (nonatomic,strong) YGChallenge *topicChallenge;
@end

@implementation YGOnboardingOfRecommendationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setOnboardingStep:2];
    [self fectchTopicChallenge];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

/**/
-(void)fectchTopicChallenge{
    if (!self.topicChallenge) {
        [YGHUD loading:self.darkv];
        [[YGChallengeService instance] fetchChallengeWithChallengeId:self.topicChallengeID sucessBlock:^(YGChallenge *challenge) {
            if (challenge) {
                self.topicChallenge = challenge;
                [self reloadData];
            }
            [YGHUD hide:self.darkv];
            
        } errorBlock:^(NSError *error) {
            [YGHUD hide:self.darkv];
            [YGHUD alertNetworkErrorIn:self.view target:self];
        }];
    }
}

-(void)retryWhenNetworkError{
    [YGHUD hide:self.darkv];
    [self fectchTopicChallenge];
}

-(void)setUpSubviews{
    [super setUpSubviews];
    [self addTitleLabelWithText:@"YOUR FIRST\nCHALLENGE"];
    [self.backGroundImgv setImage:[UIImage imageNamed:@"onboarding2.jpg"]];
    [self addSubTitleLabel];
    [self addChallengeTitleLabel];
    [self addChallengeWeekTimeLabel];
    [self addChallengeDescriptionLabel];
    [self addStartedBtn];
}

-(void)addSubTitleLabel{
    CGFloat marginX = (56/375.0)*self.view.frame.size.width;
    CGFloat marginY = CGRectGetMaxY(self.titleLabel.frame)+12*SCALE;
    CGFloat width   = self.view.frame.size.width-marginX;
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX,marginY,width,18)];
    self.subTitleLabel.text = @"We have picked a challenge for you";
    self.subTitleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.subTitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    [self.view addSubview:self.subTitleLabel];
}

-(void)addChallengeTitleLabel{
    CGFloat marginX = (56/375.0)*self.view.frame.size.width;
    CGFloat marginY = CGRectGetMaxY(self.subTitleLabel.frame)+32*SCALE;
    CGFloat width   = self.view.frame.size.width-marginX*2;
    self.challengeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX,marginY,width,20*SCALE)];
    self.challengeTitleLabel.numberOfLines = 0;
    self.challengeTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.challengeTitleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.challengeTitleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:20];
    [self.view addSubview:self.challengeTitleLabel];
}

-(void)addChallengeWeekTimeLabel{
    CGFloat marginX = (56/375.0)*self.view.frame.size.width;
    CGFloat marginY = CGRectGetMaxY(self.challengeTitleLabel.frame)+10*SCALE;
    CGFloat width   = self.view.frame.size.width-marginX*2;
    self.challengeWeekTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX,marginY,width,40*SCALE)];
    self.challengeWeekTimeLabel.numberOfLines = 0;
    self.challengeWeekTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.challengeWeekTimeLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.challengeWeekTimeLabel.font = [UIFont fontWithName:@"Lato-Bold" size:18];
    [self.view addSubview:self.challengeWeekTimeLabel];
    
}

-(void)addChallengeDescriptionLabel{
    CGFloat marginX = (56/375.0)*self.view.frame.size.width;
    CGFloat marginY = CGRectGetMaxY(self.challengeWeekTimeLabel.frame)+32*SCALE;
    CGFloat width   = self.view.frame.size.width-marginX*2;
    self.challengeDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX,marginY,width,66*SCALE)];
    self.challengeDescriptionLabel.numberOfLines = 0;
    self.challengeDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.challengeDescriptionLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.challengeDescriptionLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    [self.view addSubview:self.challengeDescriptionLabel];
}

-(void)addStartedBtn{
    self.startedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat marginX = (56/375.0)*self.view.frame.size.width;
    CGFloat marginY = CGRectGetMaxY(self.challengeDescriptionLabel.frame)+24*SCALE;
    CGFloat width   = self.view.frame.size.width-marginX*2;
    self.startedBtn.frame = CGRectMake(marginX,marginY,width,44*SCALE);
    self.startedBtn.layer.masksToBounds = YES;
    self.startedBtn.layer.cornerRadius = 22*SCALE;
    [self.startedBtn setBackgroundColor:[UIColor colorWithHexString:@"#41D395"]];
    [self.startedBtn setTitle:@"LET'S GET STARTED!" forState:UIControlStateNormal];
    [self.startedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startedBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
    [self.startedBtn addTarget:self action:@selector(started) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startedBtn];
}

-(void)reloadData{
    self.challengeTitleLabel.text = self.topicChallenge.title;
    CGSize titleFitSize = [self.challengeTitleLabel sizeThatFits:CGSizeMake(self.challengeTitleLabel.frame.size.width,MAXFLOAT)];
    CGRect titleRect = self.challengeTitleLabel.frame;
    titleRect.size.height = titleFitSize.height;
    self.challengeTitleLabel.frame = titleRect;
    //
    NSMutableAttributedString *weekTimeString = [[NSMutableAttributedString alloc] initWithString:self.topicChallenge.subTitle];
    NSMutableParagraphStyle *weekTimeStyle = [[NSMutableParagraphStyle alloc] init];
    weekTimeStyle.lineSpacing = 2*SCALE;
    weekTimeStyle.alignment = NSTextAlignmentCenter;
    [weekTimeString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Lato-Regular" size:14],
                                    NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"],
                                    NSParagraphStyleAttributeName : weekTimeStyle
                                    } range:NSMakeRange(0,weekTimeString.length)];
    self.challengeWeekTimeLabel.attributedText = weekTimeString;
    CGSize weekTimeFitSize = [self.challengeWeekTimeLabel sizeThatFits:CGSizeMake(self.challengeWeekTimeLabel.frame.size.width,MAXFLOAT)];
    CGRect weekTimeRect = self.challengeWeekTimeLabel.frame;
    weekTimeRect.size.height = weekTimeFitSize.height;
    weekTimeRect.origin.y = CGRectGetMaxY(self.challengeTitleLabel.frame)+10*SCALE;
    self.challengeWeekTimeLabel.frame = weekTimeRect;
    //
    NSMutableAttributedString *challengeDecriptionString = [[NSMutableAttributedString alloc] initWithString:self.topicChallenge.challengeDescription];
    NSMutableParagraphStyle *decriptionStyle = [[NSMutableParagraphStyle alloc] init];
    decriptionStyle.lineSpacing = 4*SCALE;
    [challengeDecriptionString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Lato-Regular" size:14],
                                               NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"],
                                               NSParagraphStyleAttributeName : decriptionStyle
                                               } range:NSMakeRange(0,challengeDecriptionString.length)];
    self.challengeDescriptionLabel.attributedText = challengeDecriptionString;
    CGSize descriptionFitSize = [self.challengeDescriptionLabel sizeThatFits:CGSizeMake(self.challengeDescriptionLabel.frame.size.width,MAXFLOAT)];
    CGRect descriptionTimeRect = self.challengeDescriptionLabel.frame;
    descriptionTimeRect.size.height = descriptionFitSize.height;
    descriptionTimeRect.origin.y = CGRectGetMaxY(self.challengeWeekTimeLabel.frame)+32*SCALE;
    self.challengeDescriptionLabel.frame = descriptionTimeRect;
    //
    CGRect startRect = self.startedBtn.frame;
    startRect.origin.y = CGRectGetMaxY(self.challengeDescriptionLabel.frame)+24*SCALE;
    self.startedBtn.frame = startRect;
    
}

#pragma mark

-(void)started{
    if (self.topicChallenge) {
        //更换挑战
        __block  UIWindow *window = [UIApplication sharedApplication].delegate.window;
        [YGHUD loading:self.darkv];
        [[YGChallengeService instance] changeChallengeWithChallengID:self.topicChallenge.ID sucessBlock:^(YGChallenge* challenge) {
            [YGHUD hide:self.darkv];
            YGOnboardingOfNotificationController *controller = [[YGOnboardingOfNotificationController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        } errorBlock:^(NSError *error) {
            [YGHUD hide:self.darkv];
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:window].yOffset=0;
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
