//
//  HttpHeader.m
//  NetworkHandler
//
//  Copyright (c) 2013 Sam Wang. All rights reserved.
//

#import "HttpHeader.h"

@implementation HttpHeader

@synthesize mHeader;

- (id)init
{
    self = [super init];
    if (self != nil) {
        mHeader = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) setHeader:(NSString *)key value:(NSString *)value
{
    if(mHeader != nil){
        [mHeader setObject:value forKey:key];
    }
}

- (NSString *) getHeader:(NSString *)key
{
    if(mHeader != nil){
        return [mHeader objectForKey:key];
    }
    return nil;
}

- (void) printAllHeader
{
    for(NSString *key in [mHeader allKeys]){
        NSLog(@"%@=%@", key, [mHeader objectForKey:key]);
    }
}

@end

