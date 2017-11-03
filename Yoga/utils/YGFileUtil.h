//
//  HHFileUtil.h
//  KaDa
//
//  Created by YangYang on 15/3/6.
//  Copyright (c) 2015年 YangYang. All rights reserved.
//

typedef enum __e_FILE_UTIL_PATH_TYPE
{
    E_FILE_UTIL_PATH_TYPE_NOT_EXSIT = 0,
    E_FILE_UTIL_PATH_TYPE_EXSIT = 1,
    E_FILE_UTIL_PATH_TYPE_FILE = 2,
    E_FILE_UTIL_PATH_TYPE_DIRECTORY = 3
} E_FILE_UTIL_PATH_TYPE;

@interface YGFileUtil : NSObject
+ (Boolean)  removeRelativePathFile:(NSString *)file;
+ (Boolean)  removeFullPathFile:(NSString *)file;
+ (Boolean)  removeFolder:(NSString *)folder;
+ (Boolean)  removeSubFolders:(NSString *)folder;
+(long long) folderSizeAtPath:(NSString*) folderPath;
+(float)     fileSize:(NSString *)filePath;     //文件大小，已乘上1024*1024； 浮点数，说明不精确哦。
+(long long)      fileLongSize:(NSString *)filePath; //文件大小，不乘上1024*1024； 精确的。

+ (void)createSuperFoldersIfNecessary:(NSString *)filePath;
//如果destPath有文件就覆盖
+ (void)copyFrom:(NSString *)sourcePath to:(NSString *)destPath;

+ (Boolean) writeToFile:(NSString *)filePath with:(NSData *)data removeIfExists:(Boolean)removeIfExists;
+ (NSString *) loadContentFromRelativePath:(NSString *)relativePath;
//保存 dictionary的，用这个方法转出来
+ (NSDictionary *)loadJsonDictionaryFromRelativePath:(NSString *)relativePath;
//对象数组 保存文件的，用这个方法转出来
+ (NSMutableArray *)loadMutableArrayObjectsFromRelativePath:(NSString *)relativePath;
/**
 * 目前大部分从服务器拉的list数据是用 array 保存json内容的。只有banner是保存的banner对象的array
 * 听书的状态是保存为 dictionary
 */
+ (Boolean) writeObect:(NSObject *)object toFile:(NSString *)filePath;
@end
