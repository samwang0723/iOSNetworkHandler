//
//  NetworkHandler.h
//  NetworkHandler
//
//  Copyright (c) 2013 Sam Wang. All rights reserved.
//

#ifndef __NETWORK_HANDLER__
#define __NETWORK_HANDLER__

#import <Foundation/Foundation.h>
#import "HttpResponse.h"
#import "HttpHeader.h"
#import "ASIHTTPRequest.h"
#import <Security/Security.h>

#define HTTP_GET    @"GET"
#define HTTP_POST   @"POST"
#define HTTP_PUT    @"PUT"
#define HTTP_DELETE @"DELETE"

#define HTTP_DEBUG 0

#if HTTP_DEBUG
#define HTTPLog(x, ...) NSLog(@"%s %d: " x, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define HTTPLog(x, ...)
#endif

@interface NetworkHandler : NSObject<NSURLConnectionDelegate> {
    NSMutableData *mResponseData;
    int mStatusCode;
    NSData *mCredential;
    NSString *mPassword;
}

+ (HttpResponse *)httpDigestAction: (NSString *)url method:(NSString *)method
                                    withAccount:(NSString *)account
                                    password:(NSString *)password
                                    header:(HttpHeader *)header
                                    withDelegate:(id) delegate;

+ (HttpResponse *)httpFormAction: (NSString *)url method:(NSString *)method
                                    withData:(NSMutableDictionary *)data
                                    header:(HttpHeader *)header
                                    withDelegate:(id) delegate;

+ (HttpResponse *)httpAction: (NSString *)url method:(NSString *)method
                                    withData:(NSString *)data
                                    header:(HttpHeader *)header
                                    withDelegate:(id) delegate;

+ (HttpResponse *)post: (NSString *)url withData:(NSString *)data header:(HttpHeader *)header withDelegate:(id) delegate;
+ (HttpResponse *)get: (NSString *)url withData:(NSString *)data header:(HttpHeader *)header withDelegate:(id) delegate;
+ (HttpResponse *)del: (NSString *)url withData:(NSString *)data header:(HttpHeader *)header withDelegate:(id) delegate;
+ (HttpResponse *)put: (NSString *)url withData:(NSString *)data header:(HttpHeader *)header withDelegate:(id) delegate;

+ (HttpResponse *)httpCredentialAction: (NSString *)url method:(NSString *)method
                                    withData:(NSString *)data
                                    header:(HttpHeader *)header
                                    withDelegate:(id) delegate
                                    credential:(NSData *)credential;
@end

#endif

