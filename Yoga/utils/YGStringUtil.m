//
//  HHStringUtil.m
//  Reading
//
//  Created by lyj on 17/8/16.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "YGStringUtil.h"

@implementation YGStringUtil
#pragma mark - json parse
+(NSString *)removeUnrecognizedJSONCharactor:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString : @"\r" withString : @""];
    string = [string stringByReplacingOccurrencesOfString : @"\n" withString : @""];
    return [string stringByReplacingOccurrencesOfString : @"\t" withString : @""];
}

#pragma  mark - sqlite escape
// ' -> ''  " -> ""
+(NSString *)propertyStringToSqliteString:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString : @"'" withString : @"''"];
    return string;
}

+(NSString *)sqliteStringToPropertyString:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString : @"''" withString : @"'"];
    return string;
}

#pragma mark - property -> setter
+ (SEL)setterFromProperty:(NSString *)property
{
    property = [property stringByReplacingOccurrencesOfString : @"_" withString : @""];
    NSString *setter = [NSString stringWithFormat:@"set%@:", [property capitalizedString]];
    SEL selector = NSSelectorFromString(setter);
    return selector;
}

#pragma mark - property -> table column
+ (NSString *)tableColumn:(NSString *)property
{
    return [property stringByReplacingOccurrencesOfString : @"_" withString : @""];
}

#pragma mark - other methods
+ (NSMutableString *)removeLastCharactor:(NSMutableString *)mutableString
{
    NSUInteger length = [mutableString length];
    if(length>0){
        [mutableString deleteCharactersInRange:NSMakeRange(length-1, 1)];
    }
    return mutableString;
}

+ (NSString *)firstCharator:(NSString *)string
{
    NSUInteger length = string.length;
    
    if(length>0){
        string = [string substringWithRange:NSMakeRange(0, 1)];
    }
    return string;
}

+ (NSString *)removeFirstAndLastCharactors:(NSString *)string
{
    NSUInteger length = [string length];
    
    if(length>1){
        string = [string substringWithRange:NSMakeRange(1, length-2)];
    }
    return string;
}

#pragma mark - path method

+ (NSString *)relativePathToFullSandboxPath:(NSString *)relativePath
{
    return [[self sandboxDocumentationPath] stringByAppendingPathComponent:relativePath];
}

+ (NSString *)sandboxDocumentationPath
{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)[0];
}

#pragma mark - transmission methods
+ (NSString *)dataToString:(NSData *)data
{
    return [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
}

+ (NSData *)stringToData:(NSString *)string
{
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - substring
+ (NSString *)tail:(NSString *)string nCharactor:(int)n
{
    if(string==nil || [string length]<n){
        return string;
    }
    return [string substringWithRange:NSMakeRange(string.length-n, n)];
}

#pragma mark - convinent method
+ (Boolean) notEmpty:(id)string
{
    return string!=nil && ![string isEqual:@""];
}

+ (Boolean) isEmpty:(id)string
{
    return string==nil || [string isEqual:@""];
}

+ (Boolean) notNull:(id)object
{
    return object!=nil && [[NSNull null] isEqual:object]==NO;
}

+ (Boolean) isNull:(id)object
{
    return object==nil || [[NSNull null] isEqual:object];
}

+(CGSize)boundString:(NSMutableAttributedString*)string inSize:(CGSize)size{
    if ([YGStringUtil isNull:string]) {
        return CGSizeZero;
    }
    return [string boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}

+(BOOL)validEmail:(NSString *)string{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [predicate evaluateWithObject:string];
}

+ (NSDictionary *)parseURLParams:(NSString *)query{
    NSURLComponents* urlComponents =  [NSURLComponents componentsWithString:query];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    NSArray* queryItems = urlComponents.queryItems;
    for (NSURLQueryItem* item in queryItems) {
        [params setObject:item.value forKey:item.name];
    }
    return params;
}
@end
