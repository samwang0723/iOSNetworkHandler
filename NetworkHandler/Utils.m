//
//  Utils.m
//  Gemball
//
//  Created by Blackloud iOS team on 8/28/13.
//  Copyright (c) 2013 Blackloud iOS team. All rights reserved.
//

#import "Utils.h"
#import "UIDevice+Identifier.h"

@implementation Utils

//
// Author: Mike_Chen3@Blacklouds.com
//
// Returns YES if the string is nil or equal to @""
// Note that [string length] == 0 can be false when [string isEqualToString:@""] is true, because these are Unicode strings.
//
+ (BOOL)isEmptyString:(NSString *)string;
{
    if (((NSNull *) string == [NSNull null]) || (string == nil)) {
        return YES;
    }
    string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

//
// Author: Mike_Chen3@Blacklouds.com
//
+ (NSString *) trimString:(NSString *) string
{
    NSString *cleanString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return cleanString;
}

//
// Author: Mike_Chen3@Blacklouds.com
//
+ (NSArray *) splitString:(NSString *) content splitCharator:(NSString *) chr
{
    NSString *text = [Utils trimString:content];
    NSArray *listItems = [text componentsSeparatedByString:chr];
    return listItems;
}

+ (NSString *) replaceString:(NSString *) text regex:(NSString *) regex replaceWith:(NSString *) replaceString{
    NSError *error = nil;
    NSRegularExpression *rgx = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [rgx stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:replaceString];
    return modifiedString;
}

#pragma mark - security
+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

+ (NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    const char lookup[] =
    {
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
        99,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
        99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
    };
    
    NSData *inputData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    long long inputLength = [inputData length];
    const unsigned char *inputBytes = [inputData bytes];
    
    long long maxOutputLength = (inputLength / 4 + 1) * 3;
    NSMutableData *outputData = [NSMutableData dataWithLength:maxOutputLength];
    unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
    
    int accumulator = 0;
    long long outputLength = 0;
    unsigned char accumulated[] = {0, 0, 0, 0};
    for (long long i = 0; i < inputLength; i++)
    {
        unsigned char decoded = lookup[inputBytes[i] & 0x7F];
        if (decoded != 99)
        {
            accumulated[accumulator] = decoded;
            if (accumulator == 3)
            {
                outputBytes[outputLength++] = (accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] = (accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] = (accumulated[2] << 6) | accumulated[3];
            }
            accumulator = (accumulator + 1) % 4;
        }
    }
    
    //handle left-over data
    if (accumulator > 0) outputBytes[outputLength] = (accumulated[0] << 2) | (accumulated[1] >> 4);
    if (accumulator > 1) outputBytes[++outputLength] = (accumulated[1] << 4) | (accumulated[2] >> 2);
    if (accumulator > 2) outputLength++;
    
    //truncate data to match actual output length
    outputData.length = outputLength;
    return outputLength? outputData: nil;
}

#pragma mark regular expression

+ (NSMutableDictionary *) extractMatchedKeyValue:(NSString *) context regex:(NSString *) rule
{
    NSError *error = nil;
    NSMutableDictionary *matchedGroups = [[NSMutableDictionary alloc] init];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:rule options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *match = [regex matchesInString:context options:0 range:NSMakeRange(0, [context length])];
    
    for (NSTextCheckingResult* matched in match)
    {
        NSRange rangeKeyMatch = [matched rangeAtIndex:1];
        NSRange rangeValueMatch = [matched rangeAtIndex:2];
        NSString *value = [[context substringWithRange:rangeValueMatch] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        SLog(@"%@=%@", [context substringWithRange:rangeKeyMatch], value);
        [matchedGroups setValue:value forKey:[context substringWithRange:rangeKeyMatch]];
    }
    return matchedGroups;
}

+ (NSMutableArray *) extractMatchedGroup:(NSString *) context regex:(NSString *) rule
{
    NSError *error = nil;
    NSMutableArray *matchedGroups = [[NSMutableArray alloc] init];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:rule options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *match = [regex matchesInString:context options:0 range:NSMakeRange(0, [context length])];
    
    for (NSTextCheckingResult* matched in match)
    {
        NSRange range = [matched range];
        SLog(@"%@", [context substringWithRange:range]);
        [matchedGroups addObject: [context substringWithRange:range]];
    }
    return matchedGroups;
}

+ (NSString *)getUTCFormatDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}

+ (NSString *)genRandStringLength:(int)len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

#pragma mark - JSON handle

+ (NSString *) nsdictionaryToJsonStr:(NSDictionary *) dic{
    if(!dic){
        return nil;
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:0
                                                         error:&error];
    
    if (jsonData) {
        return [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}

+ (NSDictionary *) jsonToNSDictionary:(NSString *)jsonString
{
    if(!jsonString){
        return [[NSDictionary alloc] init];
    }
    
    NSError *jsonParsingError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jsonParsingError];
    if (jsonObject != nil && jsonParsingError == nil && [jsonObject isKindOfClass:[NSDictionary class]]){
        SLog(@"Successfully deserialized...");
        NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
        SLog(@"Dersialized JSON Dictionary = %@", deserializedDictionary);
        return deserializedDictionary;
    }
    return nil;
}

#pragma mark - UDID
+ (NSString *) getUDID
{
    NSString *like_UDID = [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] identifierForVendor1]];
    
    return like_UDID;
}

+ (NSData *) base64Decode:(NSString *)base64string
{
    NSData *decodedData = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        decodedData = [[NSData alloc] initWithBase64EncodedString:base64string options:0]; //new in iOS 7
    }else{
        decodedData = [NSData dataFromBase64String:base64string];
    }
    
    return decodedData;
}

+ (NSString *)fetchSSID
{
    NSString *iPhoneNetworkSSID = nil;
    NSArray *ifs = (__bridge_transfer NSArray *) CNCopySupportedInterfaces();
    SLog(@"Supported interfaces: %@", ifs);
    NSDictionary *info = nil;

    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *) CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        SLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) {
            break;
        }
    }
    
    if(info != nil){
        iPhoneNetworkSSID = [info objectForKey:@"SSID"];    // Select the SSID from the network information
        SLog(@"iPhoneNetworkSSID => %@", iPhoneNetworkSSID);
    }

    return iPhoneNetworkSSID;
}

+ (int) getScreenType{
    int screentType = SCREEN_TYPE_4_INCH;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            if([UIScreen mainScreen].bounds.size.height == 568){
                // iPhone retina-4 inch
                return SCREEN_TYPE_4_INCH;
            } else{
                // iPhone retina-3.5 inch
                return SCREEN_TYPE_3_5_INCH;
            }
        }
        else {
            // not retina display
            return SCREEN_TYPE_NOT_RETINA;
        }
    }
    return screentType;
}

@end
