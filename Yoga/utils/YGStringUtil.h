//
//  HHStringUtil.h
//  Reading
//
//  Created by lyj on 17/8/16.
//  Copyright © 2017年 lyj. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface YGStringUtil : NSObject
// 去掉/t/r/n
+ (NSString *)removeUnrecognizedJSONCharactor:(NSString *)string;
// ' -> ''  双引号需要测试下，" -> ""不行，这样是数据库中看不到引号，（需要这样么？" -> \"）
+ (NSString *)propertyStringToSqliteString:(NSString *)string;
// '' -> '
+ (NSString *)sqliteStringToPropertyString:(NSString *)string;

// _uuid -> setUuid
+ (SEL)setterFromProperty:(NSString *)property;

// _uuid -> uuid
+ (NSString *)tableColumn:(NSString *)property;

+ (NSMutableString *)removeLastCharactor:(NSMutableString *)mutableString;

+ (NSString *)firstCharator:(NSString *)string;
+ (NSString *)removeFirstAndLastCharactors:(NSString *)string;

//path method
+ (NSString *)relativePathToFullSandboxPath:(NSString *)relativePath;
+ (NSString *)sandboxDocumentationPath;

//string <-> data
+ (NSString *)dataToString:(NSData *)data;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString *)tail:(NSString *)string nCharactor:(int)n;

+ (Boolean) notEmpty:(id)string;
+ (Boolean) isEmpty:(id)string;
+ (Boolean) notNull:(id)object;
+ (Boolean) isNull:(id)object;
+(BOOL)validEmail:(NSString *)string;

+ (NSDictionary *)parseURLParams:(NSString *)query;

+(CGSize)boundString:(NSMutableAttributedString*)string inSize:(CGSize)size;
@end
