//
//  HHFileUtil.m
//  KaDa
//
//  Created by YangYang on 15/3/6.
//  Copyright (c) 2015年 YangYang. All rights reserved.
//
#import "YGStringUtil.h"
#import "YGFileUtil.h"
#import "YGErrorUtil.h"
#include <sys/stat.h>
#include <dirent.h>

#define KEY_FOR_OBJECT_IN_FILE @"data"

@implementation YGFileUtil

+ (Boolean)removeRelativePathFile:(NSString *)file
{
    NSString *filePath = [YGStringUtil relativePathToFullSandboxPath:file];
    
    return [YGFileUtil removeFullPathFile:filePath];
}

+ (Boolean)removeFullPathFile:(NSString *)file
{
    Boolean succeed = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:file])
    {
        NSError *error = [YGErrorUtil getError];
        
        if ([fileManager removeItemAtPath:file error:&error] == YES)
        {
            //HHDebug(@"%@ deleted.", file);
            succeed = YES;
        }else
        {
            //HHError(@"Unable to delete file: %@", [error userInfo]);
        }
    }
    return succeed;
}

+ (Boolean)removeFolder:(NSString *)folder
{
    Boolean succeed = YES;
    NSError *error = [YGErrorUtil getError];
    E_FILE_UTIL_PATH_TYPE pathType = [YGFileUtil pathType:folder];
    
    if(pathType == E_FILE_UTIL_PATH_TYPE_DIRECTORY)
    {
        NSArray *subFolders = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:&error];
        for(NSString *path in subFolders)
        {
            NSString *fullPath = [folder stringByAppendingPathComponent:path];
            switch ([YGFileUtil pathType:fullPath])
            {
                case E_FILE_UTIL_PATH_TYPE_DIRECTORY:
                    succeed = [YGFileUtil removeFolder:fullPath] && succeed;
                    break;
                case E_FILE_UTIL_PATH_TYPE_FILE:
                    succeed = [YGFileUtil removeFullPathFile:fullPath] && succeed;
                    break;
                default:
                    break;
            }
        }
        succeed = succeed && [[NSFileManager defaultManager] removeItemAtPath:folder error:&error];
        
        if(succeed){
            //HHInfo(@"Remove folder succeed. Folder path is %@ ", folder);
        }else{
            //HHWarning(@"Remove folder failed. Folder path is %@ ", folder);
        }
    }else
    {
        //HHDebug(@"folder does not exist. %@", folder);
    }
    return succeed;
}

+ (Boolean)removeSubFolders:(NSString *)folder
{
    Boolean succeed = YES;
    NSError *error = [YGErrorUtil getError];
    NSArray *subFolders = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:&error];
    for(NSString *path in subFolders)
    {
        NSString *fullPath = [folder stringByAppendingPathComponent:path];
        switch ([YGFileUtil pathType:fullPath]) {
            case E_FILE_UTIL_PATH_TYPE_DIRECTORY:
                succeed = [YGFileUtil removeFolder:fullPath] && succeed;
                break;
            case E_FILE_UTIL_PATH_TYPE_FILE:
                succeed = [YGFileUtil removeFullPathFile:fullPath] && succeed;
                break;
            default:
                break;
        }
    }
    return succeed;
}

+(long long) folderSizeAtPath:(NSString*) folderPath{
    return [self _folderSizeAtPath:[folderPath cStringUsingEncoding:NSUTF8StringEncoding]];
}
+(long long) _folderSizeAtPath: (const char*)folderPath{
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent* child;
    while ((child = readdir(dir))!=NULL) {
        if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) || // 忽略目录 .
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) // 忽略目录 ..
                                        )) continue;
        
        int folderPathLength = (int)strlen(folderPath);
        char childPath[1024]; // 子文件的路径地址
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath+folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR){ // directory
            folderSize += [self _folderSizeAtPath:childPath]; // 递归调用子目录
            // 把目录本身所占的空间也加上
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }else if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
    }
    return folderSize;
}
+(float) fileSize:(NSString *)filePath{
    NSFileManager* manager = [NSFileManager defaultManager ];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/(1024.0*1024);
    }
    return 0;
}

+(long long) fileLongSize:(NSString *)filePath{
    NSFileManager* manager = [NSFileManager defaultManager ];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


+ (Boolean) writeToFile:(NSString *)filePath with:(NSData *)data removeIfExists:(Boolean)removeIfExists
{
    if([YGStringUtil isNull:data]){
        //HHError(@"data is nil.");
        return NO;
    }
    
    [YGFileUtil createSuperFoldersIfNecessary:filePath];
    
    if(removeIfExists && [[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [self removeRelativePathFile:filePath];
    }
    //HHDebug(@"wirte data");
    return [data writeToFile:filePath atomically:YES];
}

+ (void)createSuperFoldersIfNecessary:(NSString *)filePath
{
    NSString *directory = [filePath stringByDeletingLastPathComponent];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:directory])
    {
        NSError *error = [YGErrorUtil getError];
        [[NSFileManager defaultManager] createDirectoryAtPath:directory
                                  withIntermediateDirectories:YES    //路径不存在是否创建目录 YES代表创建(会把不存在的目录也创建)
                                                   attributes:nil    //文件属性(权限),通常写nil代表默认权限
                                                        error:&error];
        if(error.domain!=nil && error.code!=0){
            //HHWarning(@"Failed to create directory duaring saving profile image. error=%@", error);
        }
    }
}

+ (void)copyFrom:(NSString *)sourcePath to:(NSString *)destPath
{
    NSError *error = [YGErrorUtil getError];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //HHInfo(@"copy %@ to %@", sourcePath, destPath);
    if([fileManager fileExistsAtPath:destPath]){
        [fileManager removeItemAtPath:destPath error:&error];
    }
    [fileManager copyItemAtPath:sourcePath toPath:destPath error:&error];
}

+ (NSString *) loadContentFromRelativePath:(NSString *)relativePath
{
    NSString *filePath = [YGStringUtil relativePathToFullSandboxPath:relativePath];
    NSString *content = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return content!=nil?content:@"";
}

+ (NSDictionary *)loadJsonDictionaryFromRelativePath:(NSString *)relativePath
{
    NSString *filePath = [YGStringUtil relativePathToFullSandboxPath:relativePath];
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSDictionary *dic = nil;
    
    if(data!=nil)
    {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        dic = [unarchiver decodeObjectForKey:KEY_FOR_OBJECT_IN_FILE];
        [unarchiver finishDecoding];
    }
    //HHDebug(@"load dic, class %@, path %@", [dic class], relativePath);
    return dic!=nil?dic:[NSDictionary dictionary];
}

+ (NSMutableArray *)loadMutableArrayObjectsFromRelativePath:(NSString *)relativePath
{
    NSString *filePath = [YGStringUtil relativePathToFullSandboxPath:relativePath];
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSMutableArray *array = nil;
    
    if(data!=nil)
    {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        array = [unarchiver decodeObjectForKey:KEY_FOR_OBJECT_IN_FILE];
        [unarchiver finishDecoding];
    }
    //HHDebug(@"load array, class %@, path %@", [array class], relativePath);
    return array!=nil?array:[NSMutableArray array];
}


+ (Boolean) writeObect:(NSObject *)object toFile:(NSString *)filePath
{
    //HHDebug(@"wirte object, class %@, path: %@", [object class], filePath);
    NSMutableData *fileData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:fileData];
    [archiver encodeObject:object forKey:KEY_FOR_OBJECT_IN_FILE];
    [archiver finishEncoding];
    return [YGFileUtil writeToFile:filePath with:fileData removeIfExists:YES];
}

#pragma mark - private method
+ (E_FILE_UTIL_PATH_TYPE)pathType:(NSString *)folder
{
    BOOL isDir = NO;
    E_FILE_UTIL_PATH_TYPE pathType = E_FILE_UTIL_PATH_TYPE_NOT_EXSIT;
    
    Boolean exists = [[NSFileManager defaultManager] fileExistsAtPath:folder isDirectory:&isDir];
    if(exists && isDir==NO)
    {
        pathType = E_FILE_UTIL_PATH_TYPE_FILE;
    }
    if(isDir)
    {
        pathType = E_FILE_UTIL_PATH_TYPE_DIRECTORY;
    }
    return pathType;
}

+(Boolean)exist:(E_FILE_UTIL_PATH_TYPE)pathType
{
    return E_FILE_UTIL_PATH_TYPE_FILE == pathType || E_FILE_UTIL_PATH_TYPE_DIRECTORY == pathType;
}

@end
