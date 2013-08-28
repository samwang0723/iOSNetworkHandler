//
//  HttpHeader.h
//  NetworkHandler
//
//  Copyright (c) 2013 Sam Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HTTP_CONTENT_LENGTH     @"Content-Length"
#define HTTP_CONTENT_TYPE       @"Content-Type"
#define HTTP_ACCEPT             @"Accept"
#define HTTP_AUTHORIZATION      @"Authorization"
#define HTTP_ACCEPT_CHARSET     @"Accept-Charset"
#define HTTP_ACCEPT_ENCODING    @"Accept-Encoding"
#define HTTP_RANGE              @"Range"
#define HTTP_USER_AGENT         @"User-Agent"
#define HTTP_HOST               @"Host"
#define HTTP_COOKIE             @"Cookie"
#define HTTP_REFERER            @"Referer"
#define HTTP_USER_AGENT         @"User-Agent"
#define HTTP_CONNECTION         @"Connection"

#define HTTP_CONTENT_TYPE_JSON      @"application/json"
#define HTTP_CONTENT_TYPE_BINARY    @"application/octet-stream"
#define HTTP_CONTENT_TYPE_XML       @"text/xml"
#define HTTP_CONTENT_TYPE_HTML      @"text/html"
#define HTTP_CONTENT_TYPE_IMG_JPEG  @"image/jpeg"
#define HTTP_CONTENT_TYPE_IMG_PNG   @"image/png"

@interface HttpHeader : NSObject {
    NSMutableDictionary *mHeader;
}

@property (nonatomic, retain) NSMutableDictionary *mHeader;

- (void) setHeader:(NSString *)key value:(NSString *)value;
- (NSString *) getHeader:(NSString *)key;
- (void) printAllHeader;

@end
