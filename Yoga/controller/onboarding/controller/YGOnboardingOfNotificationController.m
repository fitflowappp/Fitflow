//
//  YGOnboardingOfNotificationController.m
//  Yoga
//
//  Created by lyj on 2017/12/19.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGStringUtil.h"
#import "YGAppDelegate.h"
#import "UIColor+Extension.h"
//#import "YGSignUpController.h"
#import "YGNetworkService.h"
#import "YGOnboardingOfNotificationController.h"

@interface YGOnboardingOfNotificationController ()
@property (nonatomic,strong) UILabel  *subTitleLabel;
@property (nonatomic,strong) UIButton *openReminderBtn;
@property (nonatomic,strong) UIButton *notOpenReminderBtn;
@property (nonatomic,strong) UILabel  *openReminderTipLabel;
@end

@implementation YGOnboardingOfNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    [self setUpSubviews];
}

-(void)setUpSubviews{
    [super setUpSubviews];
    [self addTitleLabelWithText:@"CONSISTENCY\nIS KEY"];
    [self.backGroundImgv setImage:[UIImage imageNamed:@"onboarding3.jpg"]];
    [self addSubTitleLabel];
    [self addOpenReminderTipLabel];
    [self addOpenReminderBtn];
    [self addNotOpenReminderBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setOnboardingStep:3];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toSingup:) name:@"KEY_USER_NOTIFICATIONSETTINGS_GRANTED" object:nil];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KEY_USER_NOTIFICATIONSETTINGS_GRANTED" object:nil];
}

-(void)addSubTitleLabel{
    CGFloat marginX = (56/375.0)*self.view.frame.size.width;
    CGFloat marginY = CGRectGetMaxY(self.titleLabel.frame)+12*SCALE;
    CGFloat width   = self.view.frame.size.width-marginX*2;
    NSMutableAttributedString *subtitleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Users with reminders are %@ more likely to reach their goals. Let us send you regular reminders.",@"80%"]];
    NSMutableParagraphStyle *subtitleStyle = [[NSMutableParagraphStyle alloc] init];
    subtitleStyle.lineSpacing = 4*SCALE;
    [subtitleString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Lato-Regular" size:14],
                                    NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"],
                                    NSParagraphStyleAttributeName : subtitleStyle
                                    } range:NSMakeRange(0,subtitleString.length)];
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX,marginY,width,110*SCALE)];
    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.attributedText = subtitleString;
    [self.subTitleLabel sizeToFit];
    [self.view addSubview:self.subTitleLabel];
}

-(void)addOpenReminderTipLabel{
    CGFloat marginX = (56/375.0)*self.view.frame.size.width;
    CGFloat marginY = CGRectGetMaxY(self.subTitleLabel.frame)+24*SCALE;
    CGFloat width   = self.view.frame.size.width-marginX*2;
    self.openReminderTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX,marginY,width,18)];
    self.openReminderTipLabel.text = @"You can turn notifications off at any time.";
    self.openReminderTipLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.openReminderTipLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    self.openReminderTipLabel.numberOfLines = 0;
    [self.openReminderTipLabel sizeToFit];
    [self.view addSubview:self.openReminderTipLabel];
}

-(void)addOpenReminderBtn{
    CGFloat marginX = (56/375.0)*self.view.frame.size.width;
    CGFloat marginY = CGRectGetMaxY(self.openReminderTipLabel.frame)+24*SCALE;
    CGFloat width   = self.view.frame.size.width-marginX*2;
    self.openReminderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openReminderBtn.frame = CGRectMake(marginX,marginY,width,44*SCALE);
    self.openReminderBtn.layer.masksToBounds = YES;
    self.openReminderBtn.layer.cornerRadius = 22*SCALE;
    [self.openReminderBtn setBackgroundColor:[UIColor colorWithHexString:@"#41D395"]];
    [self.openReminderBtn setTitle:@"TURN ON REMINDERS" forState:UIControlStateNormal];
    [self.openReminderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.openReminderBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
    [self.openReminderBtn addTarget:self action:@selector(openReminder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.openReminderBtn];
}

-(void)addNotOpenReminderBtn{
    CGFloat marginX = (56/375.0)*self.view.frame.size.width;
    CGFloat marginY = CGRectGetMaxY(self.openReminderBtn.frame)+16*SCALE;
    CGFloat width   = self.view.frame.size.width-marginX*2;
    self.notOpenReminderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.notOpenReminderBtn.frame = CGRectMake(marginX,marginY,width,44*SCALE);
    self.notOpenReminderBtn.layer.masksToBounds = YES;
    self.notOpenReminderBtn.layer.cornerRadius = 22*SCALE;
    self.notOpenReminderBtn.layer.borderWidth = 0.5;
    self.notOpenReminderBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.notOpenReminderBtn setTitle:@"NOT NOW" forState:UIControlStateNormal];
    [self.notOpenReminderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.notOpenReminderBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
    [self.notOpenReminderBtn addTarget:self action:@selector(notOpenReminder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.notOpenReminderBtn];
}

-(void)openReminder{
    YGAppDelegate *appDelegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate registerUserNotification];
}

-(void)notOpenReminder{
    [self toSingup:nil];
}

-(void)toSingup:(NSNotification*)notic{
    NSNumber *granted = notic.object;
    if (granted.boolValue==YES) {
        [[YGNetworkService instance] networkWithUrl:URLForge(@"/yoga/config/notification") requsetType:PUT params:@{@"notification":@(YES)} successBlock:^(id data) {
            NSLog(@"msg: network setting notification sucess in onBoardingNotificationController");
        } errorBlock:^(NSError *error) {
            
        }];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        YGAppDelegate *appDelegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate initTabBarController];
        
        
        
//        YGSignUpController *controller = [[YGSignUpController alloc] init];
//        controller.fromOnboarding = YES;
//        [self.navigationController pushViewController:controller animated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
