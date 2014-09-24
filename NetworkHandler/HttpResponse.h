//
//  HttpResponse.h
//  NetworkHandler
//
//  Copyright (c) 2013 Sam Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpResponse : NSObject {
    int mStatusCode;
    NSString *mResponse;
    NSString *mAuthenticate;
    NSString *mSessionId;
}

@property(nonatomic, assign) int mStatusCode;
@property(nonatomic, strong) NSString *mResponse;
@property(nonatomic, strong) NSString *mAuthenticate;
@property(nonatomic, strong) NSString *mSessionId;

@end
