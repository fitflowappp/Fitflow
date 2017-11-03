//
//  YGWorkoutCompletedController.m
//  Yoga
//
//  Created by lyj on 2017/9/25.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGAppDelegate.h"
#import "YGNetworkService.h"
#import "UIColor+Extension.h"
#import "YGWorkoutCompletedController.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
@interface YGWorkoutCompletedController ()<FBSDKSharingDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation YGWorkoutCompletedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.workout.title;
    [self setLeftNavigationItem];
    [self addScrollView];
    [self addSubviews];
}

-(void)addScrollView{
    CGFloat btnMargin = 16*SCALE;
    CGFloat btnWidth  = GET_SCREEN_WIDTH-btnMargin*2;
    CGFloat btnHeight = btnWidth*(96/686.0);
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,MIN(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT),MAX(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT)-NAV_HEIGHT-(btnHeight*2+btnMargin*3))];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
}

-(void)addSubviews{
    UIImageView *congratulationImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Right-c"]];
    congratulationImgv.center = CGPointMake(self.scrollView.frame.size.width/2,56*SCALE+congratulationImgv.frame.size.height/2);
    [self.scrollView addSubview:congratulationImgv];
    //
    UILabel *congratulationTipLabel = [[UILabel alloc] init];
    congratulationTipLabel.frame = CGRectMake(0,CGRectGetMaxY(congratulationImgv.frame)+24*SCALE,self.scrollView.frame.size.width,29*SCALE);
    congratulationTipLabel.text = @"Congratulations!";
    congratulationTipLabel.textAlignment = NSTextAlignmentCenter;
    congratulationTipLabel.font = [UIFont fontWithName:@"Lato-Black" size:24*SCALE];
    congratulationTipLabel.textColor = [UIColor colorWithHexString:@"#0EC07F"];
    [self.scrollView addSubview:congratulationTipLabel];
    //
    UILabel *completedTipLabel = [[UILabel alloc] init];
    completedTipLabel.frame = CGRectMake(0,CGRectGetMaxY(congratulationTipLabel.frame)+24*SCALE,self.scrollView.frame.size.width,29*SCALE);
    completedTipLabel.text = @"YOU COMPLETED:";
    completedTipLabel.textAlignment = NSTextAlignmentCenter;
    completedTipLabel.font = [UIFont fontWithName:@"Lato-Bold" size:17*SCALE];
    completedTipLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    [self.scrollView addSubview:completedTipLabel];
    //
    UILabel *completedTitleLabel =  [[UILabel alloc] init];
    completedTitleLabel.frame = CGRectMake(0,CGRectGetMaxY(completedTipLabel.frame)+8*SCALE,self.scrollView.frame.size.width,38*SCALE);
    completedTitleLabel.text = [NSString stringWithFormat:@"%@:\n%@",self.challenge.title,self.workout.title];
    completedTitleLabel.numberOfLines = 0;
    completedTitleLabel.textAlignment = NSTextAlignmentCenter;
    completedTitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16*SCALE];
    completedTitleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    [completedTitleLabel sizeToFit];
    completedTitleLabel.frame = CGRectMake(0,CGRectGetMaxY(completedTipLabel.frame)+24*SCALE,self.scrollView.frame.size.width,completedTitleLabel.frame.size.height);
    [self.scrollView addSubview:completedTitleLabel];
    //
    UILabel *completedMessageLable = [[UILabel alloc] init];
    completedMessageLable.frame = CGRectMake(16*SCALE,CGRectGetMaxY(completedTitleLabel.frame)+24*SCALE,self.scrollView.frame.size.width-32*SCALE,1);
    completedMessageLable.text = self.workout.message;
    completedMessageLable.numberOfLines = 0;
    completedMessageLable.textAlignment = NSTextAlignmentCenter;
    completedMessageLable.font = [UIFont fontWithName:@"Lato-Regular" size:16*SCALE];
    completedMessageLable.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    [completedMessageLable sizeToFit];
    completedMessageLable.frame = CGRectMake(16*SCALE,CGRectGetMaxY(completedTitleLabel.frame)+24*SCALE,self.scrollView.frame.size.width-32*SCALE,completedMessageLable.frame.size.height);
    [self.scrollView addSubview:completedMessageLable];
    //
    CGFloat btnMargin = 16*SCALE;
    CGFloat btnWidth  = MIN(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT)-btnMargin*2;
    CGFloat btnHeight = btnWidth*(96/686.0);
    UIButton *nextWorkoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextWorkoutBtn.frame = CGRectMake(btnMargin,MAX(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT)-btnMargin-btnHeight-NAV_HEIGHT,self.scrollView.frame.size.width-btnMargin*2,btnHeight);
    nextWorkoutBtn.layer.masksToBounds = YES;
    nextWorkoutBtn.layer.borderWidth = 2.0f;
    nextWorkoutBtn.backgroundColor = [UIColor whiteColor];
    nextWorkoutBtn.layer.cornerRadius = nextWorkoutBtn.frame.size.height/2;
    nextWorkoutBtn.layer.borderColor = [UIColor colorWithHexString:@"#0EC07F"].CGColor;
    [nextWorkoutBtn setTitle:@"NEXT WORKOUT" forState:UIControlStateNormal];
    [nextWorkoutBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
    [nextWorkoutBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16*SCALE]];
    [nextWorkoutBtn addTarget:self action:@selector(nextWorkout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextWorkoutBtn];
    //
    UIButton *shareToFaceBookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareToFaceBookBtn.frame = CGRectMake(btnMargin,nextWorkoutBtn.frame.origin.y-btnMargin-btnHeight,self.scrollView.frame.size.width-btnMargin*2,btnHeight);
    shareToFaceBookBtn.layer.masksToBounds = YES;
    shareToFaceBookBtn.layer.cornerRadius = shareToFaceBookBtn.frame.size.height/2;
    [shareToFaceBookBtn setBackgroundColor:[UIColor colorWithHexString:@"#4A90E2"]];
    [shareToFaceBookBtn setTitle:@"SHARE ON FACEBOOK" forState:UIControlStateNormal];
    [shareToFaceBookBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16*SCALE]];
    [shareToFaceBookBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [shareToFaceBookBtn addTarget:self action:@selector(shareToFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareToFaceBookBtn];
    UIImageView *faceBookIconImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook-white"]];
    faceBookIconImgv.center = CGPointMake(btnMargin+faceBookIconImgv.frame.size.width/2,shareToFaceBookBtn.frame.size.height/2);
    [shareToFaceBookBtn addSubview:faceBookIconImgv];
    self.scrollView.contentSize = CGSizeMake(0,CGRectGetMaxY(completedMessageLable.frame));
}

-(void)nextWorkout{
    YGAppDelegate *delegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
    if (self.fromDefaultWorkout==YES) {
        [delegate initTabBarController];
    }else{
        [delegate backToWorkout];
    }
}

-(void)shareToFacebook{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"http://www.fitflow.io/ios/download"];
    FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2://"]]) {
        shareDialog.mode = FBSDKShareDialogModeNative;
    }else{
        shareDialog.mode = FBSDKShareDialogModeBrowser;
    }
    shareDialog.delegate = self;
    shareDialog.shareContent = content;
    shareDialog.fromViewController = self;
    [shareDialog show];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/yoga/share",cRequestDomain];
    [[YGNetworkService instance] networkWithUrl:requestUrl requsetType:PUT successBlock:^(id data) {
        NSLog(@"post yoga share sucess");
    } errorBlock:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    
    
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    
    
}

@end
