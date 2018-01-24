//
//  YGDownLoadVideoService.m
//  Yoga
//
//  Created by lyj on 2017/9/20.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGFileUtil.h"
#import "YGStringUtil.h"
#import "YGRoutine+Extension.h"
#import "YGDownVideoService.h"
#import "YGDownVideoCommand.h"
@interface YGDownVideoService()
@end
@implementation YGDownVideoService
+ (YGDownVideoService *)instance{
    static YGDownVideoService *downLoadVideoService = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        downLoadVideoService = [[YGDownVideoService alloc] init];
    });
    return downLoadVideoService;
}

-(void)downVideoWithRoutine:(YGRoutine*)routine successBlock:(SUCCESS_BLOCK)successBlock errorBlock:(FAILURE_BLOCK)errorBlock{
    YGDownVideoCommand *command = [[YGDownVideoCommand alloc] init];
    command.requestUrl = routine.videoUrl;
    NSString *filePath = [YGStringUtil relativePathToFullSandboxPath:[NSString stringWithFormat:@"routine/%@.mp4",routine.vedioID]];
    [YGFileUtil createSuperFoldersIfNecessary:filePath];
    command.filePath = filePath;
    command.successBlock = successBlock;
    command.errorBlock = errorBlock;
    [command execute];
}

-(void)downSessionAllVideo:(YGSession*)sesssion{
    NSArray *routineList = sesssion.routineList;
    //NSString *currentRoutineID = sesssion.currentRoutineID;
    if (routineList.count) {
        int currentPlayRoutineIndex = 0;
//        for (int i = 0; i<routineList.count;i++) {
//            YGRoutine *routine = routineList[i];
//            if ([routine.ID isEqualToString:currentRoutineID]) {
//                currentPlayRoutineIndex = i;
//                break;
//            }
//        }
        NSMutableArray *downloadSequenceList = [NSMutableArray array];
        /*down from:currentRoutineIndex+1 To routineList.count*/
        for (int needDownIndex= currentPlayRoutineIndex+1;needDownIndex<routineList.count;needDownIndex++) {
            [downloadSequenceList addObject:@(needDownIndex)];
        }
        /*down from:0 To:currentRoutineIndex*/
        for (int needDownIndex= currentPlayRoutineIndex-1;needDownIndex>=0;needDownIndex--) {
            [downloadSequenceList addObject:@(needDownIndex)];
        }
        /*down load currentRoutineIndex*/
        [downloadSequenceList addObject:@(currentPlayRoutineIndex)];
        
        dispatch_semaphore_t downSemaphore = dispatch_semaphore_create(1);
        for (NSNumber *number in downloadSequenceList) {
            YGRoutine *needDownRoutine = sesssion.routineList[number.integerValue];
            if ([needDownRoutine downLoaded]==NO) {
                dispatch_semaphore_wait(downSemaphore,DISPATCH_TIME_FOREVER);
                [self downVideoWithRoutine:needDownRoutine successBlock:^(id data) {
                    dispatch_semaphore_signal(downSemaphore);
                    NSLog(@"%@ finish",needDownRoutine.title);
                } errorBlock:^(NSError *error) {
                    dispatch_semaphore_signal(downSemaphore);
                }];
            }else{
                NSLog(@"video has loaded");
            }
        }
    }
}
@end
