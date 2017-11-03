//
//  YGSchedulingController.m
//  Yoga
//
//  Created by lyj on 2017/10/12.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import "YGHUD.h"
#import "YGTextHeader.h"
#import "YGAppDelegate.h"
#import "YGKeychainUtil.h"
#import "YGRefreshHeader.h"
#import <EventKit/EventKit.h>
#import "UIColor+Extension.h"
#import "YGUserNetworkService.h"
#import "YGSchedulingSwithCell.h"
#import "YGReminderScheduleView.h"
#import "YGSchedulingEntranceCell.h"
#import "YGSchedulingController.h"
#import "YGWorkoutScheduleView.h"
static NSString *SCHEDULING_SWITCH_CELLID = @"shedulingSwithCellID";
static NSString *SCHEDULING_ENTRANCE_CELLID = @"shedulingEntranceCellID";
static NSString *SCHEDULING_TEXT_HEADERID = @"shedulingTextHeaderID";

#define YOGA_CALENDAR_EVENT_KEY @"yogaCalendarEventKey"

@interface YGSchedulingController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic) BOOL optenPushNotification;
@property (nonatomic,strong) NSMutableDictionary *scheduleInfo;
@end

@implementation YGSchedulingController{
    YGWorkoutScheduleView   *workoutScheduleView;
    YGReminderScheduleView  *reminderScheduleView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItem];
    [self setCollectionView];
    [self.navigationItem setTitle:@"Scheduling"];
    [YGHUD loading:self.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchUserScheduleInfo];
    self.navigationController.navigationBarHidden = NO;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)WillEnterForeground{
    if (self.scheduleInfo.allKeys.count) {
        [self handleLocalSettings];
        [self.collectionView reloadData];
    }
    
}
-(void)handleLocalSettings{
    /*同步本地设置*/
    if (self.scheduleInfo.allKeys.count) {
        if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]==YES) {
            /*本地通知关闭*/
            if ([[UIApplication sharedApplication] currentUserNotificationSettings].types==UIUserNotificationTypeNone){
                [self.scheduleInfo setObject:@(0) forKey:@"notification"];
            }else{
                /*本地通知打开*/
                if ([[self.scheduleInfo objectForKey:@"notification"] boolValue]==NO) {
                    //[self.scheduleInfo setObject:@(1) forKey:@"notification"];
                }
            }
        }else{
            [self.scheduleInfo setObject:@(0) forKey:@"notification"];
            
        }
        EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
        if (status!=EKAuthorizationStatusAuthorized) {
            /*本地日历关闭*/
            [self.scheduleInfo setObject:@(0) forKey:@"remider"];
        }else{
            //[self.scheduleInfo setObject:@(1) forKey:@"remider"];
        }
        [[YGUserNetworkService instance] scheduleWithParams:self.scheduleInfo sucessBlock:^(NSDictionary *result) {
            int code = [[result objectForKey:@"code"] intValue];
            if (code==1) {
                NSLog(@"msg: post local settings sucess");
            }else{
                NSLog(@"msg: post local settings error");
            }
        } failureBlcok:^(NSError *error) {
            NSLog(@"msg: post local settings error");
        }];
    }
}

-(void)fetchUserScheduleInfo{
    __weak typeof(self) ws = self;
    [[YGUserNetworkService instance] fetchUserScheduleInfoSucessBlock:^(NSMutableDictionary* scheduleInfo) {
        if (scheduleInfo.allKeys.count) {
            ws.scheduleInfo = scheduleInfo;
        }
        [ws handleLocalSettings];
        [YGHUD hide:ws.view];
        [ws.collectionView reloadData];
        [ws.collectionView.mj_header endRefreshing];
    } failureBlcok:^(NSError *error) {
        [YGHUD hide:ws.view];
        if (ws.scheduleInfo.count) {
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
        }else{
            [YGHUD alertNetworkErrorIn:ws.view target:ws];
        }
        [ws.collectionView.mj_header endRefreshing];
    }];
}

-(void)retryWhenNetworkError{
    [YGHUD loading:self.view];
    [self fetchUserScheduleInfo];
}

#pragma mark UI
-(void)setCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,GET_SCREEN_WIDTH, GET_SCREEN_HEIGHT-NAV_HEIGHT) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[YGSchedulingSwithCell class] forCellWithReuseIdentifier:SCHEDULING_SWITCH_CELLID];
    [self.collectionView registerClass:[YGSchedulingEntranceCell class] forCellWithReuseIdentifier:SCHEDULING_ENTRANCE_CELLID];
    [self.collectionView registerClass:[YGTextHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SCHEDULING_TEXT_HEADERID];
    self.collectionView.mj_header = [YGRefreshHeader headerAtTarget:self action:@selector(fetchUserScheduleInfo) view:self.collectionView];
    [self.view addSubview:self.collectionView];
}

#pragma mark UICollectionView-Datasouce
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.scheduleInfo.allKeys.count==0) {
        return 0;
    }
    BOOL openPush = [[self.scheduleInfo objectForKey:@"notification"] boolValue];
    BOOL openCalendar = [[self.scheduleInfo objectForKey:@"remider"] boolValue];
    if (openPush==NO&&openCalendar==NO) {
        return 2;
    }
    return 4;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>1) {
        YGSchedulingEntranceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SCHEDULING_ENTRANCE_CELLID forIndexPath:indexPath];
        if (indexPath.row==2) {
            cell.titleText = @"Set your workout schedule";
            NSArray *scheduleDays = [self.scheduleInfo objectForKey:@"schedulingDays"];
            NSMutableString *scheduleSubtitle = [[NSMutableString alloc] init];
            BOOL allOpen = YES;
            for (int i=0;i<scheduleDays.count;i++) {
                NSNumber *status = scheduleDays[i];
                if (status.boolValue==YES) {
                    if (i==0) {
                        [scheduleSubtitle appendString:@"Mon "];
                    }else if (i==1){
                        [scheduleSubtitle appendString:@"Tue "];
                    }else if (i==2){
                        [scheduleSubtitle appendString:@"Wed "];
                    }else if (i==3){
                        [scheduleSubtitle appendString:@"Thu "];
                    }else if (i==4){
                        [scheduleSubtitle appendString:@"Fri "];
                    }else if (i==5){
                        [scheduleSubtitle appendString:@"Sat "];
                    }else if (i==6){
                        [scheduleSubtitle appendString:@"Sun "];
                    }
                }else{
                    allOpen = NO;
                }
            }
            if (allOpen==YES) {
                cell.subTitleText = @"Every day";
            }else{
                cell.subTitleText = [scheduleSubtitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
        }else{
            cell.titleText = @"Set your reminder time";
            NSNumber *reminderTimeNumber = [self.scheduleInfo objectForKey:@"schedulingTime"];
            NSDate *reminderTimeDate = [NSDate dateWithTimeIntervalSince1970:reminderTimeNumber.longLongValue/1000];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"hh:mm a"];
            dateFormatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            NSString* remiderDateString = [dateFormatter stringFromDate:reminderTimeDate];
            cell.subTitleText = remiderDateString;
        }
        return cell;
    }
    YGSchedulingSwithCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SCHEDULING_SWITCH_CELLID forIndexPath:indexPath];
    if (indexPath.row==0) {
        cell.titleText = @"Push Notifications";
        SEL action = @selector(optenPushNotification:);
        if ([cell.switchBtn respondsToSelector:action]==NO) {
            [cell.switchBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        }
        NSNumber *reminder = [self.scheduleInfo objectForKey:@"notification"];
        [cell.switchBtn setOn:reminder.boolValue animated:NO];
        cell.switchBtn.tag = 10000;
    }else{
        cell.titleText = @"Calendar Reminders";
        SEL action = @selector(openCalendar:);
        if ([cell.switchBtn respondsToSelector:action]==NO) {
            [cell.switchBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        }
        NSNumber *openPush = [self.scheduleInfo objectForKey:@"remider"];
        [cell.switchBtn setOn:openPush.boolValue animated:NO];
        cell.switchBtn.tag =10001;
    }
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    YGTextHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SCHEDULING_TEXT_HEADERID forIndexPath:indexPath];
    NSString *headerText = @"Schedule reminders to help keep you on track";
    NSMutableAttributedString *aHeaderText = [[NSMutableAttributedString alloc] initWithString:headerText];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.tailIndent = -16*self.scale;
    style.headIndent = 16*self.scale;
    style.firstLineHeadIndent = 16*self.scale;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[UIFont fontWithName:@"Lato-Regular" size:16*self.scale] forKey:NSFontAttributeName];
    [params setObject:[UIColor colorWithHexString:@"#4A4A4A"]forKey:NSForegroundColorAttributeName];
    [params setObject:style forKey:NSParagraphStyleAttributeName];
    [aHeaderText addAttributes:params range:NSMakeRange(0,aHeaderText.length)];
    header.text = aHeaderText;
    
    return header;
}

#pragma mark UICollectionView-Layout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(8*self.scale,16*self.scale,0,16*self.scale);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.width-32*self.scale,64*self.scale);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.scheduleInfo.allKeys.count==0) {
        return CGSizeZero;
    }
    return CGSizeMake(collectionView.frame.size.width,19*self.scale);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        workoutScheduleView = [[YGWorkoutScheduleView alloc] initWithFrame:CGRectMake(0,0,GET_SCREEN_WIDTH, GET_SCREEN_HEIGHT)];
        workoutScheduleView.scheduleStatusList = [self.scheduleInfo objectForKey:@"schedulingDays"];
        [[UIApplication sharedApplication].delegate.window addSubview:workoutScheduleView];
        SEL action = @selector(workoutSchedule);
        if ([workoutScheduleView.sureBtn respondsToSelector:action]==NO) {
            [workoutScheduleView.sureBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        }
    }else if (indexPath.row==3){
        reminderScheduleView = [[YGReminderScheduleView alloc] initWithFrame:CGRectMake(0,0,GET_SCREEN_WIDTH, GET_SCREEN_HEIGHT)];
        [[UIApplication sharedApplication].delegate.window addSubview:reminderScheduleView];
        SEL action = @selector(reminderSchedule);
        if ([reminderScheduleView.sureBtn respondsToSelector:action]==NO) {
            [reminderScheduleView.sureBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

-(void)workoutSchedule{
    __weak typeof(self) ws = self;
    __block YGWorkoutScheduleView *blockWorkoutScheduleView = workoutScheduleView;
    [YGHUD loading:self.view];
    [[YGUserNetworkService instance] scheduleWithParams:self.scheduleInfo sucessBlock:^(NSDictionary *result) {
        [YGHUD hide:ws.view];
        int code = [[result objectForKey:@"code"] intValue];
        if (code==1) {
            [blockWorkoutScheduleView hide];
            [ws.collectionView reloadData];
            if ([[ws.scheduleInfo objectForKey:@"remider"] boolValue]==YES) {
                [ws openLocalCalendar];
            }
        }else{
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
        }
    } failureBlcok:^(NSError *error) {
        [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
    }];
}

-(void)reminderSchedule{
    NSDate *remiderDate = reminderScheduleView.datePicker.date;
    __weak typeof(self) ws = self;
    __block YGReminderScheduleView *blockReminderScheduleView = reminderScheduleView;
    [YGHUD loading:self.view];
    [ws.scheduleInfo setObject:[NSNumber numberWithLongLong:[remiderDate timeIntervalSince1970]*1000] forKey:@"schedulingTime"];
    [[YGUserNetworkService instance] scheduleWithParams:self.scheduleInfo sucessBlock:^(NSDictionary *result) {
        [YGHUD hide:ws.view];
        int code = [[result objectForKey:@"code"] intValue];
        if (code==1) {
            [blockReminderScheduleView hide];
            [ws.collectionView reloadData];
            if ([[ws.scheduleInfo objectForKey:@"remider"] boolValue]==YES) {
                [ws openLocalCalendar];
            }
        }else{
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
        }
    } failureBlcok:^(NSError *error) {
        [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
    }];
}

-(void)optenPushNotification:(UISwitch*)sender{
    if (sender.tag ==10001) {
        return;
    }
    
    if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]==NO) {
        YGAppDelegate *delegate = (YGAppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate registerUserNotification];
        dispatch_async(dispatch_get_main_queue(), ^{
            [sender setOn:!sender.isOn animated:YES];
        });
        return;
    }else{
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types==UIUserNotificationTypeNone) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setOn:!sender.isOn animated:YES];
            });
            
            [[[UIAlertView alloc] initWithTitle:@"\"Fitflow\" Would like to Send you Notifications" message:@"Notifications may include alerts,sounds,and icon badges.These can be configured in Settings." delegate:self cancelButtonTitle:@"Don't Allow" otherButtonTitles:@"OK", nil] show];
            return;
        }
    }
    
    __weak typeof(self) ws = self;
    BOOL staus = sender.isOn;
    [YGHUD loading:self.view];
    [ws.scheduleInfo setObject:@(staus) forKey:@"notification"];
    [[YGUserNetworkService instance] scheduleWithParams:self.scheduleInfo sucessBlock:^(NSDictionary *result) {
        int code = [[result objectForKey:@"code"] intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [YGHUD hide:ws.view];
            if (code!=1) {
                [ws.scheduleInfo setObject:@(!staus) forKey:@"notification"];
                [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
            }
            [ws.collectionView reloadData];
        });
        
    } failureBlcok:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws.scheduleInfo setObject:@(!staus) forKey:@"notification"];
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
            [ws.collectionView reloadData];
        });
    }];
}

-(void)openCalendar:(UISwitch*)sender{
    if (sender.tag==10000) {
        return;
    }
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (status==EKAuthorizationStatusNotDetermined) {
        EKEventStore *eventDB = [[EKEventStore alloc ] init];
        [eventDB requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [self openCalendar:sender];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [sender setOn:!sender.isOn animated:YES];
                });
            }
        }];
        return;
    }else if (status==EKAuthorizationStatusDenied||status==EKAuthorizationStatusRestricted){
        dispatch_async(dispatch_get_main_queue(), ^{
            [sender setOn:!sender.isOn animated:YES];
        });
        [[[UIAlertView alloc] initWithTitle:@"\"Fitflow\" Would like to Access Your Calendar" message:@"Build a habit. Change start today.Turn off anytime." delegate:self cancelButtonTitle:@"Don't Allow" otherButtonTitles:@"OK", nil] show];
        /**/
        return;
    }
    __weak typeof(self) ws = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [YGHUD loading:ws.view];
    });
    BOOL staus = sender.isOn;
    [self.scheduleInfo setObject:@(staus) forKey:@"remider"];
    [[YGUserNetworkService instance] scheduleWithParams:self.scheduleInfo sucessBlock:^(NSDictionary *result) {
        [YGHUD hide:ws.view];
        int code = [[result objectForKey:@"code"] intValue];
        if (code==1) {
            if (staus==YES) {
                [ws openLocalCalendar];
            }else{
                [ws closeLocalCalendar];
                [ws tryAgainCloseLocalCalendar];
            }
        }else{
            [ws.scheduleInfo setObject:@(!staus) forKey:@"remider"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws.collectionView reloadData];
                [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
            });
        }
        [ws.collectionView reloadData];
    } failureBlcok:^(NSError *error) {
        [ws.scheduleInfo setObject:@(!staus) forKey:@"remider"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws.collectionView reloadData];
            [YGHUD alertMsg:NETWORK_ERROR_ALERT at:ws.view];
        });
        
    }];
}

-(void)openLocalCalendar{
    [self closeLocalCalendar];
    /*close local calendar again*/
    if ([self tryAgainCloseLocalCalendar]==NO) {
        return;
    }
    NSArray *sheduleDays = [self.scheduleInfo objectForKey:@"schedulingDays"];
    NSMutableArray *remainWeeks;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        remainWeeks = [NSMutableArray arrayWithObjects:[EKRecurrenceDayOfWeek dayOfWeek:EKWeekdayMonday],
                       [EKRecurrenceDayOfWeek dayOfWeek:EKWeekdayTuesday],
                       [EKRecurrenceDayOfWeek dayOfWeek:EKWeekdayWednesday],
                       [EKRecurrenceDayOfWeek dayOfWeek:EKWeekdayThursday],
                       [EKRecurrenceDayOfWeek dayOfWeek:EKWeekdayFriday],
                       [EKRecurrenceDayOfWeek dayOfWeek:EKWeekdaySaturday],
                       [EKRecurrenceDayOfWeek dayOfWeek:EKWeekdaySunday],nil];
        
    }else{
        remainWeeks = [NSMutableArray arrayWithObjects:[EKRecurrenceDayOfWeek dayOfWeek:EKMonday],
                       [EKRecurrenceDayOfWeek dayOfWeek:EKTuesday],
                       [EKRecurrenceDayOfWeek dayOfWeek:EKWednesday],
                       [EKRecurrenceDayOfWeek dayOfWeek:EKThursday],
                       [EKRecurrenceDayOfWeek dayOfWeek:EKFriday],
                       [EKRecurrenceDayOfWeek dayOfWeek:EKSaturday],
                       [EKRecurrenceDayOfWeek dayOfWeek:EKSunday],nil];
    }
    NSMutableArray *removeWeeks = [NSMutableArray array];
    for (int i = 0;i<sheduleDays.count;i++) {
        NSNumber *status = sheduleDays[i];
        if (status.boolValue==NO) {
            [removeWeeks addObject:remainWeeks[i]];
        }
    }
    [remainWeeks removeObjectsInArray:removeWeeks];
    if (remainWeeks.count) {
        EKRecurrenceDayOfWeek *firstWeekInRemainWeeks = remainWeeks[0];
        NSDate *currentDate = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
        NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:currentDate];
        NSInteger currentWeekNumber = theComponents.weekday;
        NSNumber *scheduleTimeNumber = [self.scheduleInfo objectForKey:@"schedulingTime"];
        NSDate *scheduleDate = [NSDate dateWithTimeIntervalSince1970:scheduleTimeNumber.longLongValue/1000];
        NSDate *findDate = [NSDate dateWithTimeInterval:(firstWeekInRemainWeeks.dayOfTheWeek-currentWeekNumber)*24*60*60 sinceDate:scheduleDate];
        EKEventStore *eventDB = [[EKEventStore alloc ] init];
        [eventDB requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                EKEvent *event  = [EKEvent eventWithEventStore:eventDB]; //创建一个日历事件
                event.title     = @"Fitflow Yoga";  //标题
                event.startDate = findDate;
                event.endDate   = [NSDate dateWithTimeInterval:60*60 sinceDate:event.startDate];
                [event setCalendar:eventDB.defaultCalendarForNewEvents]; //添加calendar  required
                [event addAlarm:[EKAlarm alarmWithRelativeOffset:0]];
                NSError *error;
                EKRecurrenceRule *rule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 daysOfTheWeek:remainWeeks daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:nil];
                
                [event addRecurrenceRule:rule];
                BOOL sucess = [eventDB saveEvent:event span:EKSpanThisEvent error:&error];
                if (sucess==YES) {
                    if (event.eventIdentifier) {
                        [YGKeychainUtil save:@{YOGA_CALENDAR_EVENT_KEY:event.eventIdentifier}];
                    }
                }
            }else{
                NSLog(@"calendar unAuthorized");
            }
        }];
    }
}

-(BOOL)closeLocalCalendar{
    BOOL sucess = YES;
    EKEventStore *eventDB = [[EKEventStore alloc ] init];
    NSError *error = nil;
    EKEvent *calendarEvent = [eventDB eventWithIdentifier:[YGKeychainUtil load:YOGA_CALENDAR_EVENT_KEY]];
    sucess = [eventDB removeEvent:calendarEvent span:EKSpanFutureEvents error:&error];
    if (sucess==NO&&error==nil) {
        sucess = YES;
    }
    return sucess;
}

-(BOOL)tryAgainCloseLocalCalendar{
    EKEventStore *eventDB = [[EKEventStore alloc ] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Create the start date components
    NSDateComponents *tenDayAgoComponents = [[NSDateComponents alloc] init];
    tenDayAgoComponents.day = -10;
    NSDate *tenDayAgo = [calendar dateByAddingComponents:tenDayAgoComponents
                                                  toDate:[NSDate date]
                                                 options:0];
    
    // Create the end date components
    NSDateComponents *tenDayFromNowComponents = [[NSDateComponents alloc] init];
    tenDayFromNowComponents.day = 10;
    NSDate *tenDayFromNow = [calendar dateByAddingComponents:tenDayFromNowComponents
                                                      toDate:[NSDate date]
                                                     options:0];
    
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [eventDB predicateForEventsWithStartDate:tenDayAgo
                                                              endDate:tenDayFromNow
                                                            calendars:nil];
    
    // Fetch all events that match the predicate
    NSArray *events = [eventDB eventsMatchingPredicate:predicate];
    for (EKEvent *event in events) {
        if ([event.title isEqualToString:@"Fitflow Yoga"]) {
            NSError *error = nil;
            BOOL sucess =  [eventDB removeEvent:event span:EKSpanFutureEvents error:&error];
            if (sucess==NO&&error==nil) {
                sucess = YES;
            }
            if (sucess==NO) {
                return NO;
                break;
            }
        }
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}
@end
