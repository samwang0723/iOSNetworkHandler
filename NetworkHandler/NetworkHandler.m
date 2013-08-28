//
//  NetworkHandler.m
//  NetworkHandler
//
//  Copyright (c) 2013 Sam Wang. All rights reserved.
//

#import "NetworkHandler.h"

// Need DummyInterface of NSURLRequest to use private method
@interface NSURLRequest (DummyInterface)
+ (BOOL )allowsAnyHTTPSCertificateForHost:(NSString *)host;
+ (void )setAllowsAnyHTTPSCertificate:(BOOL )allow forHost:(NSString *)host;
@end

@implementation NetworkHandler

+ (HttpResponse *)httpAction: (NSString *)url method:(NSString *)method withData:(NSString *)data
                     withSSL:(BOOL)ssl header:(HttpHeader *)header {
    
    NSString *fixedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *targetUrl = [NSURL URLWithString:fixedURL];
    NSData *postData = nil;
    NSString *postLength = @"0";
    if(nil != data){
        postData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"postData: %@", data);
    }
    postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:targetUrl];
    [request setHTTPMethod:method];
    
    NSDictionary *httpHeader = [header mHeader];
    for(NSString *key in [httpHeader allKeys]){
        [request setValue:[httpHeader objectForKey:key] forHTTPHeaderField:key];
    }
    
    if(nil != postData){
        [request setHTTPBody:postData];
    }
    
    /* when we user https, we need to allow any HTTPS cerificates, so add the one line code,to tell teh NSURLRequest to accept any https certificate, i'm not sure about the security aspects
     */
    if(ssl){
        [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[targetUrl host]];
    }
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    
    NSLog(@"STATUS:%d", [((NSHTTPURLResponse *)response) statusCode]);
    NSLog(@"ERROR:%@", error);
    NSLog(@"RESPONSE:%@", responseData);
    
    HttpResponse *httpResponse = [[HttpResponse alloc] init];
    [httpResponse setMStatusCode:[((NSHTTPURLResponse *)response) statusCode]];
    [httpResponse setMResponse:responseData];
    return httpResponse;
}

+ (HttpResponse *)post: (NSString *)url withData:(NSString *)data withSSL:(BOOL)ssl header:(HttpHeader *)header {
    return [self httpAction:url method:@"POST" withData:data withSSL:ssl header:header];
}

+ (HttpResponse *)get: (NSString *)url withData:(NSString *)data withSSL:(BOOL)ssl header:(HttpHeader *)header{
    return [self httpAction:url method:@"GET" withData:data withSSL:ssl header:header];
}

+ (HttpResponse *)del: (NSString *)url withData:(NSString *)data withSSL:(BOOL)ssl header:(HttpHeader *)header{
    return [self httpAction:url method:@"DELETE" withData:data withSSL:ssl header:header];
}

+ (HttpResponse *)put: (NSString *)url withData:(NSString *)data withSSL:(BOOL)ssl header:(HttpHeader *)header{
    return [self httpAction:url method:@"PUT" withData:data withSSL:ssl header:header];
}
@end

