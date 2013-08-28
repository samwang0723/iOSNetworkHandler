//
//  NetworkHandler.h
//  NetworkHandler
//
//  Copyright (c) 2013 Sam Wang. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "HttpResponse.h"
#import "HttpHeader.h"

#define HTTP_GET    @"GET"
#define HTTP_POST   @"POST"
#define HTTP_PUT    @"PUT"
#define HTTP_DELETE @"DELETE"

@interface NetworkHandler : NSObject

+ (HttpResponse *)httpAction: (NSString *)url method:(NSString *)method withData:(NSString *)data withSSL:(BOOL)ssl header:(HttpHeader *)header;

+ (HttpResponse *)post: (NSString *)url withData:(NSString *)data withSSL:(BOOL) ssl header:(HttpHeader *)header;
+ (HttpResponse *)get: (NSString *)url withData:(NSString *)data withSSL:(BOOL) ssl header:(HttpHeader *)header;
+ (HttpResponse *)del: (NSString *)url withData:(NSString *)data withSSL:(BOOL) ssl header:(HttpHeader *)header;
+ (HttpResponse *)put: (NSString *)url withData:(NSString *)data withSSL:(BOOL) ssl header:(HttpHeader *)header;

@end

