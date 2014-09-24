//
//  Utils.h
//  Gemball
//
//  Created by Blackloud iOS team on 8/28/13.
//  Copyright (c) 2013 Blackloud iOS team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>
#import "NSData+Base64.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#define JSON_MAIN 0
#define JSON_ARRAY 1

#define SCREEN_TYPE_3_5_INCH     1
#define SCREEN_TYPE_4_INCH       2
#define SCREEN_TYPE_NOT_RETINA   3

#define SLog(x, ...) NSLog(@"%s %d: " x, __FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface Utils : NSObject {
}

+ (BOOL) isEmptyString:(NSString *) string;
+ (NSString *) trimString:(NSString *) string;
+ (NSArray *) splitString:(NSString *) content splitCharator:(NSString *) chr;
+ (NSString *) replaceString:(NSString *) text regex:(NSString *) regex replaceWith:(NSString *) replaceString;
+ (NSString *) md5:(NSString *) input;
+ (NSString*) sha1:(NSString*)input;

+ (NSMutableDictionary *) extractMatchedKeyValue:(NSString *) context regex:(NSString *) rule;
+ (NSMutableArray *) extractMatchedGroup:(NSString *) context regex:(NSString *) rule;

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
+ (NSString *)getUTCFormatDate:(NSDate *)localDate;

+ (NSString *) genRandStringLength:(int)len;
+ (NSString *) nsdictionaryToJsonStr:(NSDictionary *) dic;
+ (NSDictionary *) jsonToNSDictionary:(NSString *)jsonString;
+ (NSString *) getUDID;
+ (NSData *) base64Decode:(NSString *)base64string;

+ (NSString *) getErrorString:(int)code fromPage:(id)page;
+ (NSString *) getErrorString:(int)code;
+ (NSString *) restructThumbnailUrl:(NSString *)urlPath;
+ (NSString *) fetchSSID;

+ (int) getScreenType;

@end
