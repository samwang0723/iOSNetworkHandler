//
//  HttpResponse.m
//  NetworkHandler
//
//  Copyright (c) 2013 Sam Wang. All rights reserved.
//

#import "HttpResponse.h"

@implementation HttpResponse

@synthesize mResponse;

- (int)getMStatusCode {
    return mStatusCode;
}

- (NSString *)getMResponse {
    return mResponse;
}

- (void)setMStatusCode:(int)status {
    mStatusCode = status;
}

- (void)setMResponse:(NSString *)responseData {
    mResponse = responseData;
}

@end
