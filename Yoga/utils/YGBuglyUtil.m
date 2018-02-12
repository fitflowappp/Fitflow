//
//  YGBuglyUtil.m
//  Yoga
//
//  Created by 何侨 on 2018/1/31.
//  Copyright © 2018年 lyj. All rights reserved.
//

#import "YGBuglyUtil.h"
#import <FirebaseDatabase/FirebaseDatabase.h>
#import <FirebaseCrash/FirebaseCrash.h>
#import <FirebaseAuth/FirebaseAuth.h>
@import Firebase;
@implementation YGBuglyUtil
+ (void)postBugWithGoogleDB:(NSError *)error
{
//    [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
    [FIRDatabase setLoggingEnabled:true];

    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
        
        [ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"1");
        }];
        [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"1");
        }];
//    FIRDatabaseQuery * query=[[ref child:@"loginfo"] queryEqualToValue:@0];
//    [ref setValue:@{@"error":@"76755"}];
//    [tmp setValue:@"1111" withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
//        NSLog(@"error");
//    }];
//    }];
}
@end
