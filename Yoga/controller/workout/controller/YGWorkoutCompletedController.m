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
#import "YGOpenReminderAlert.h"
#import <EventKit/EventKit.h>
#import "YGSchedulingController.h"
#import "YGWorkoutCompletedController.h"
@interface YGWorkoutCompletedController ()
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation YGWorkoutCompletedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.workout.title;
    [self setLeftNavigationItem];
    [self addScrollView];
    [self addSubviews];
    [self addReminderAlert];
}

-(void)addScrollView{
    CGFloat btnMargin = 16*SCALE;
    CGFloat btnWidth  = MIN(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT)-btnMargin*2;
    CGFloat btnHeight = btnWidth*(96/686.0);
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,MIN(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT),MAX(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT)-NAV_HEIGHT-(btnHeight*2+btnMargin*3))];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
}

-(void)addSubviews{
    UIImageView *congratulationImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Right-c"]];
    congratulationImgv.center = CGPointMake(self.scrollView.frame.size.width/2,72+congratulationImgv.frame.size.height/2);
    [self.scrollView addSubview:congratulationImgv];
    //
    UILabel *congratulationTipLabel = [[UILabel alloc] init];
    congratulationTipLabel.frame = CGRectMake(0,CGRectGetMaxY(congratulationImgv.frame)+24,self.scrollView.frame.size.width,29);
    congratulationTipLabel.text = @"Congratulations!";
    congratulationTipLabel.textAlignment = NSTextAlignmentCenter;
    congratulationTipLabel.font = [UIFont fontWithName:@"Lato-Black" size:24];
    congratulationTipLabel.textColor = [UIColor colorWithHexString:@"#0EC07F"];
    [self.scrollView addSubview:congratulationTipLabel];
    //
    UILabel *completedTipLabel = [[UILabel alloc] init];
    completedTipLabel.frame = CGRectMake(0,CGRectGetMaxY(congratulationTipLabel.frame)+20,self.scrollView.frame.size.width,25);
    completedTipLabel.text = @"YOU COMPLETED:";
    completedTipLabel.textAlignment = NSTextAlignmentCenter;
    completedTipLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    completedTipLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    [self.scrollView addSubview:completedTipLabel];
    //
    UILabel *completedTitleLabel =  [[UILabel alloc] init];
    completedTitleLabel.frame = CGRectMake(16*SCALE,CGRectGetMaxY(completedTipLabel.frame)+4,self.scrollView.frame.size.width-32*SCALE,38);
    completedTitleLabel.text = [NSString stringWithFormat:@"%@",self.workout.title];
    completedTitleLabel.numberOfLines = 0;
    completedTitleLabel.textAlignment = NSTextAlignmentCenter;
    completedTitleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    completedTitleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    [completedTitleLabel sizeToFit];
    completedTitleLabel.frame = CGRectMake(16*SCALE,CGRectGetMaxY(completedTipLabel.frame)+4,self.scrollView.frame.size.width-32*SCALE,completedTitleLabel.frame.size.height);
    [self.scrollView addSubview:completedTitleLabel];
    //
    UILabel *completedMessageLable = [[UILabel alloc] init];
    completedMessageLable.frame = CGRectMake(16*SCALE,CGRectGetMaxY(completedTitleLabel.frame)+24,self.scrollView.frame.size.width-32*SCALE,1);
    completedMessageLable.text = self.workout.message;
    completedMessageLable.numberOfLines = 0;
    completedMessageLable.textAlignment = NSTextAlignmentCenter;
    completedMessageLable.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    completedMessageLable.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    [completedMessageLable sizeToFit];
    completedMessageLable.frame = CGRectMake(16*SCALE,CGRectGetMaxY(completedTitleLabel.frame)+24,self.scrollView.frame.size.width-32*SCALE,completedMessageLable.frame.size.height);
    [self.scrollView addSubview:completedMessageLable];
    //
    CGFloat btnMargin = 16*SCALE;
    CGFloat btnWidth  = MIN(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT)-btnMargin*2;
    CGFloat btnHeight = btnWidth*(44/343.0);
    UIButton *nextWorkoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextWorkoutBtn.frame = CGRectMake(btnMargin,MAX(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT)-btnMargin*1.5-btnHeight-NAV_HEIGHT,self.scrollView.frame.size.width-btnMargin*2,btnHeight);
    nextWorkoutBtn.layer.masksToBounds = YES;
    nextWorkoutBtn.layer.borderWidth = 0.5f;
    nextWorkoutBtn.backgroundColor = [UIColor whiteColor];
    nextWorkoutBtn.layer.cornerRadius = nextWorkoutBtn.frame.size.height/2;
    nextWorkoutBtn.layer.borderColor = [UIColor colorWithHexString:@"#0EC07F"].CGColor;
    [nextWorkoutBtn setTitle:@"NEXT" forState:UIControlStateNormal];
    [nextWorkoutBtn setTitleColor:[UIColor colorWithHexString:@"#0EC07F"] forState:UIControlStateNormal];
    [nextWorkoutBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [nextWorkoutBtn addTarget:self action:@selector(nextWorkout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextWorkoutBtn];
    //
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(btnMargin,nextWorkoutBtn.frame.origin.y-btnMargin-btnHeight,self.scrollView.frame.size.width-btnMargin*2,btnHeight);
    shareBtn.layer.masksToBounds = YES;
    shareBtn.layer.cornerRadius = shareBtn.frame.size.height/2;
    [shareBtn setBackgroundColor:[UIColor colorWithHexString:@"#41D395"]];
    [shareBtn setTitle:@"SHARE THIS CLASS" forState:UIControlStateNormal];
    [shareBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [shareBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(didSelectShare:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    self.scrollView.contentSize = CGSizeMake(0,CGRectGetMaxY(completedMessageLable.frame));
}

-(void)addReminderAlert{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (status!=EKAuthorizationStatusAuthorized) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_USER_NOT_OPEN_CALENDAR_FOREVER"]==NO) {
            UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
            YGOpenReminderAlert *openReminder = [[YGOpenReminderAlert alloc] initWithFrame:CGRectMake(0,0,MIN(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT),MAX(GET_SCREEN_WIDTH,GET_SCREEN_HEIGHT))];
            [openReminder.openReminderBtn addTarget:self action:@selector(openReminder:) forControlEvents:UIControlEventTouchUpInside];
            [openReminder.notShowAgainBtn addTarget:self action:@selector(notAskMeReminder:) forControlEvents:UIControlEventTouchUpInside];
            [mainWindow addSubview:openReminder];
        }
    }
}

-(void)openReminder:(UIButton*)sender{
    YGOpenReminderAlert *openReminder = (YGOpenReminderAlert*)sender.superview.superview;
    [openReminder hide];
    YGSchedulingController *controller = [[YGSchedulingController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)notAskMeReminder:(UIButton*)sender{
    YGOpenReminderAlert *openReminder = (YGOpenReminderAlert*)sender.superview.superview;
    [openReminder hide];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"KEY_USER_NOT_OPEN_CALENDAR_FOREVER"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)nextWorkout{
    [self.navigationController popToRootViewControllerAnimated:NO];
    YGAppDelegate *delegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate backToWorkout];
}

-(void)didSelectShare:(UIButton*)sender{
    if (self.workout.shareUrl) {
        NSString *shareTitle = [NSString stringWithFormat:@"I just finished this yoga class '%@' on the Fitflow app. I loved it. I think you will too. And it's free. %@",self.workout.title,self.workout.shareUrl];
        [self shareWithContent:@[shareTitle]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
