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
}

@property(nonatomic, retain) NSString *mResponse;

- (int)getMStatusCode;
- (NSString *)getMResponse;
- (void)setMStatusCode:(int)status;
- (void)setMResponse:(NSString *)responseData;

@end
