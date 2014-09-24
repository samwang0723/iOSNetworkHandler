//
//  NetworkHandler.m
//  NetworkHandler
//
//  Copyright (c) 2013 Sam Wang. All rights reserved.
//

#import "NetworkHandler.h"
#import "ASIFormDataRequest.h"
#import "Utils.h"

@implementation NetworkHandler


+ (HttpResponse *)httpDigestAction: (NSString *)url method:(NSString *)method withAccount:(NSString *)account password:(NSString *)password header:(HttpHeader *)header withDelegate:(id) delegate {
    
    @try {
        NSData *temp = [url dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *fixedURL = [[NSString alloc] initWithData:temp encoding:NSASCIIStringEncoding];
        HTTPLog(@"URL: %@", fixedURL);
        
        NSURL *targetUrl = [NSURL URLWithString:fixedURL];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:targetUrl];
        request.downloadProgressDelegate = delegate;
        [request setRequestMethod:method];
        NSDictionary *httpHeader = [header mHeader];
        for(NSString *key in [httpHeader allKeys]){
            [request addRequestHeader:key value:[httpHeader objectForKey:key]];
        }
        request.shouldPresentCredentialsBeforeChallenge = YES;
        [request setUsername:account];
        [request setPassword:password];
        
        [request addRequestHeader:@"Content-Type" value:@"*/*"];
        [request addRequestHeader:@"Accept" value:@"*/*"];
        [request setValidatesSecureCertificate:NO];
        // Set the amount of time to hang on to a persistent connection before it should expire to 2 minutes
        [request setPersistentConnectionTimeoutSeconds:60];
        [request setShowAccurateProgress:YES];
        
        [request startSynchronous];
        
        HTTPLog(@"STATUS: %d", [request responseStatusCode]);
        HTTPLog(@"ERROR: %@", [request responseStatusMessage]);
        if ([request responseStatusCode] == 0 || [Utils isEmptyString:[request responseString]]){
            return nil;
        }
        const char *c = [[request responseString] cStringUsingEncoding:NSISOLatin1StringEncoding];
        NSString *newString = [[NSString alloc]initWithCString:c encoding:NSUTF8StringEncoding];
        HTTPLog(@"RESPONSE: %@", newString);
        
        HttpResponse *httpResponse = [[HttpResponse alloc] init];
        [httpResponse setMStatusCode:[request responseStatusCode]];
        [httpResponse setMResponse:newString];
        
        NSDictionary *dict = [request responseHeaders];
        if(dict != nil){
            NSString *authenicate = [dict objectForKey:@"WWW-Authenticate"];
            [httpResponse setMAuthenticate:authenicate];
            HTTPLog(@"WWW-Authenticate: %@", authenicate);
        }
        return httpResponse;
    }@catch (NSException *exception) {
        HTTPLog(@"exception=%@", exception);
    }@finally {
    }
    return nil;
}

+ (HttpResponse *)httpFormAction: (NSString *)url method:(NSString *)method withData:(NSMutableDictionary *)data
                          header:(HttpHeader *)header withDelegate:(id) delegate {
    @try {
        NSData *temp = [url dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *fixedURL = [[NSString alloc] initWithData:temp encoding:NSASCIIStringEncoding];
        HTTPLog(@"URL: %@", fixedURL);
        
        NSURL *targetUrl = [NSURL URLWithString:fixedURL];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:targetUrl];
        request.downloadProgressDelegate = delegate;
        [request setRequestMethod:method];
        NSDictionary *httpHeader = [header mHeader];
        for(NSString *key in [httpHeader allKeys]){
            [request addRequestHeader:key value:[httpHeader objectForKey:key]];
        }
        
        [request addRequestHeader:@"Content-Type" value:@"*/*"];
        [request addRequestHeader:@"Accept" value:@"application/json, text/javascript, */*; q=0.01"];
        [request setValidatesSecureCertificate:NO];
        // Set the amount of time to hang on to a persistent connection before it should expire to 2 minutes
        [request setPersistentConnectionTimeoutSeconds:60];
        if(data != nil){
            NSEnumerator *enumerator = [data keyEnumerator];
            id value;
            while ((value = [enumerator nextObject])) {
                HTTPLog(@"Key=%@, Value=%@", (NSString *)value, [data objectForKey:value]);
                [request setPostValue:[data objectForKey:value] forKey:(NSString *)value];
            }
        }
        [request setShowAccurateProgress:YES];
        
        [request startSynchronous];
        
        HTTPLog(@"STATUS: %d", [request responseStatusCode]);
        HTTPLog(@"ERROR: %@", [request responseStatusMessage]);
        if ([request responseStatusCode] == 0){
            return nil;
        }
        const char *c = [[request responseString] cStringUsingEncoding:NSISOLatin1StringEncoding];
        NSString *newString = [[NSString alloc]initWithCString:c encoding:NSUTF8StringEncoding];
        HTTPLog(@"RESPONSE: %@", newString);
        
        HttpResponse *httpResponse = [[HttpResponse alloc] init];
        [httpResponse setMStatusCode:[request responseStatusCode]];
        [httpResponse setMResponse:newString];
        
        NSDictionary *dict = [request responseHeaders];
        if(dict != nil){
            NSString *authenicate = [dict objectForKey:@"WWW-Authenticate"];
            [httpResponse setMAuthenticate:authenicate];
            HTTPLog(@"WWW-Authenticate: %@", authenicate);
        }
        
        return httpResponse;
    }@catch (NSException *exception) {
        SLog(@"exception=%@", exception);
    }@finally {
    }
    return nil;
}


+ (HttpResponse *)httpAction: (NSString *)url method:(NSString *)method withData:(NSString *)data
                      header:(HttpHeader *)header withDelegate:(id) delegate {
    @try {
        NSData *temp = [url dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *fixedURL = [[NSString alloc] initWithData:temp encoding:NSASCIIStringEncoding];
        HTTPLog(@"URL: %@", fixedURL);
        
        NSURL *targetUrl = [NSURL URLWithString:fixedURL];
        NSData *postData = nil;
        NSString *postLength = @"0";
        if(nil != data){
            postData = [data dataUsingEncoding:NSUTF8StringEncoding];
            HTTPLog(@"postData: %@", data);
        }
        postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:targetUrl];
        request.downloadProgressDelegate = delegate;
        [request setRequestMethod:method];
        NSDictionary *httpHeader = [header mHeader];
        for(NSString *key in [httpHeader allKeys]){
            [request addRequestHeader:key value:[httpHeader objectForKey:key]];
        }
        [request addRequestHeader:@"Content-Length" value:postLength];
        [request setValidatesSecureCertificate:NO];
        // Set the amount of time to hang on to a persistent connection before it should expire to 2 minutes
        [request setPersistentConnectionTimeoutSeconds:60];
        if(postData != nil){
            [request appendPostData:postData];
        }
        [request setShowAccurateProgress:YES];
        
        [request startSynchronous];
        
        HTTPLog(@"STATUS: %d", [request responseStatusCode]);
        HTTPLog(@"ERROR: %@", [request responseStatusMessage]);
        if ([request responseStatusCode] == 0){
            return nil;
        }
        const char *c = [[request responseString] cStringUsingEncoding:NSISOLatin1StringEncoding];
        NSString *newString = [[NSString alloc]initWithCString:c encoding:NSUTF8StringEncoding];
        HTTPLog(@"RESPONSE: %@", newString);
        
        HttpResponse *httpResponse = [[HttpResponse alloc] init];
        [httpResponse setMStatusCode:[request responseStatusCode]];
        [httpResponse setMResponse:newString];
        
        NSDictionary *dict = [request responseHeaders];
        if(dict != nil){
            
            NSEnumerator *keyEnum = [dict keyEnumerator];
            __weak NSString *key = nil;
            while (key = [keyEnum nextObject]) {
                HTTPLog(@"key=%@, value=%@", key, [dict objectForKey:key]);
            }
            NSString *cookie = [dict objectForKey:@"Set-Cookie"];
            [httpResponse setMSessionId:cookie];
            
            NSString *authenicate = [dict objectForKey:@"WWW-Authenticate"];
            [httpResponse setMAuthenticate:authenicate];
        }
        
        return httpResponse;
    }@catch (NSException *exception) {
        SLog(@"exception=%@", exception);
    }@finally {
    }
    return nil;
}

+ (HttpResponse *)httpCredentialAction: (NSString *)url method:(NSString *)method withData:(NSString *)data
                                header:(HttpHeader *)header withDelegate:(id) delegate credential:(NSData *)credential {
    
    NSString *fixedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *targetUrl = [NSURL URLWithString:fixedURL];
    NSData *postData = nil;
    NSString *postLength = @"0";
    if(nil != data){
        postData = [data dataUsingEncoding:NSUTF8StringEncoding];
        HTTPLog(@"postData: %@", data);
    }
    postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:targetUrl];
    request.downloadProgressDelegate = delegate;
    [request setRequestMethod:method];
    NSDictionary *httpHeader = [header mHeader];
    for(NSString *key in [httpHeader allKeys]){
        [request addRequestHeader:key value:[httpHeader objectForKey:key]];
    }
    [request addRequestHeader:@"Content-Length" value:postLength];
    [request addRequestHeader:@"Content-Type" value:@"*/*"];
    [request addRequestHeader:@"Accept" value:@"*/*"];
    [request setValidatesSecureCertificate:NO];
    
    // Now, let's grab the certificate (included in the resources of the test app)
    SecIdentityRef identity = NULL;
    SecTrustRef trust = NULL;
    [NetworkHandler extractIdentity:&identity andTrust:&trust fromPKCS12Data:credential];
    [request setClientCertificateIdentity:identity];
    [request setClientCertificates:[NSArray arrayWithObject:(__bridge id)identity]];
    
    SecCertificateRef myReturnedCertificate = NULL;
    
    OSStatus status = SecIdentityCopyCertificate (identity, &myReturnedCertificate);
    NSString* summaryString = @"";
    if (status == 0) {
        CFStringRef certSummary = SecCertificateCopySubjectSummary(myReturnedCertificate);
        summaryString = [[NSString alloc] initWithString:(__bridge NSString *)certSummary];
        HTTPLog(@"summaryString=%@", summaryString);
    }
    
    // Add an additional certificate (where cert is a SecCertificateRef)
    //[request setClientCertificates:[NSArray arrayWithObject:(id)cert]];
    
    // Set the amount of time to hang on to a persistent connection before it should expire to 2 minutes
    [request setPersistentConnectionTimeoutSeconds:60];
    if(postData != nil){
        [request appendPostData:postData];
    }
    [request setShowAccurateProgress:YES];
    
    [request startSynchronous];
    
    HTTPLog(@"STATUS: %d", [request responseStatusCode]);
    HTTPLog(@"ERROR: %@", [request responseStatusMessage]);
    if ([request responseStatusCode] == 0){
        return nil;
    }
    const char *c = [[request responseString] cStringUsingEncoding:NSISOLatin1StringEncoding];
    NSString *newString = [[NSString alloc]initWithCString:c encoding:NSUTF8StringEncoding];
    HTTPLog(@"RESPONSE: %@", newString);
    
    HttpResponse *httpResponse = [[HttpResponse alloc] init];
    [httpResponse setMStatusCode:[request responseStatusCode]];
    [httpResponse setMResponse:newString];
    
    NSDictionary *dict = [request responseHeaders];
    if(dict != nil){
        NSString *authenicate = [dict objectForKey:@"WWW-Authenticate"];
        [httpResponse setMAuthenticate:authenicate];
        HTTPLog(@"WWW-Authenticate: %@", authenicate);
    }
    
    return httpResponse;
}

+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data
{
    HTTPLog(@"extractIdentity");
    OSStatus securityError = errSecSuccess;
    
    CFStringRef password = CFSTR("123456");
    const void *keys[] =   { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys,values, 1,NULL, NULL);
    
    //	NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObject:@"123456" forKey:(id)CFBridgingRelease(kSecImportExportPassphrase)];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((CFDataRef)CFBridgingRetain(inPKCS12Data),optionsDictionary,&items);
    
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        HTTPLog(@"extractIdentity failed with error code %d",(int)securityError);
        return NO;
    }
    return YES;
}

+ (HttpResponse *)post: (NSString *)url withData:(NSString *)data header:(HttpHeader *)header withDelegate:(id) delegate{
    return [self httpAction:url method:@"POST" withData:data header:header withDelegate:(id) delegate];
}

+ (HttpResponse *)get: (NSString *)url withData:(NSString *)data header:(HttpHeader *)header withDelegate:(id) delegate{
    return [self httpAction:url method:@"GET" withData:data header:header withDelegate:(id) delegate];
}

+ (HttpResponse *)del: (NSString *)url withData:(NSString *)data header:(HttpHeader *)header withDelegate:(id) delegate{
    return [self httpAction:url method:@"DELETE" withData:data header:header withDelegate:(id) delegate];
}

+ (HttpResponse *)put: (NSString *)url withData:(NSString *)data header:(HttpHeader *)header withDelegate:(id) delegate{
    return [self httpAction:url method:@"PUT" withData:data header:header withDelegate:(id) delegate];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //HTTPLog(@"in didReceiveResponse ");
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    mStatusCode = [httpResponse statusCode];
    mResponseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //HTTPLog(@"in didReceiveData ");
    [mResponseData appendData:data];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    //HTTPLog(@"canAuthenticateAgainstProtectionSpace");
    return YES;
}

- (NSURLCredential *)credentialWithIdentity:(SecIdentityRef)identity certificates:(NSArray *)certArray persistence:(NSURLCredentialPersistence)persistence {
    
    //HTTPLog(@"credentialWithIdentity");
    
    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"RoviSys" ofType:@"pfx"];
    NSData *certData   = [[NSData alloc] initWithContentsOfFile:certPath];
    
    SecIdentityRef myIdentity = NULL;
    
    SecCertificateRef myCert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certData);
    SecCertificateRef certArray1[1] = { myCert };
    CFArrayRef myCerts = CFArrayCreate(NULL, (void *)certArray1, 1, NULL);
    CFRelease(myCert);
    NSURLCredential *credential = [NSURLCredential credentialWithIdentity:myIdentity
                                                             certificates:(__bridge NSArray *)myCerts
                                                              persistence:NSURLCredentialPersistencePermanent];
    CFRelease(myCerts);
    return credential;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    //HTTPLog(@"in didReceiveAuthenticationChallenge ");
    
    CFDataRef inPKCS12Data = (__bridge CFDataRef)mCredential;
    SecIdentityRef identity;
    [self extractIdentity :inPKCS12Data :&identity];
    
    SecCertificateRef certificate = NULL;
    SecIdentityCopyCertificate (identity, &certificate);
    
    const void *certs[] = {certificate};
    CFArrayRef certArray = CFArrayCreate(kCFAllocatorDefault, certs, 1, NULL);
    
    NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identity certificates:(__bridge NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
    [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //HTTPLog(@"in didFailWithError ");
    HTTPLog(@"Unresolved error %@, %@", error, [error userInfo]);
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    //HTTPLog(@"willCacheResponse");
    return nil;     // Never cache
}

- (OSStatus)extractIdentity:(CFDataRef)inP12Data :(SecIdentityRef*)identity {
    //HTTPLog(@"extractIdentity");
    OSStatus securityError = errSecSuccess;
    CFStringRef password = CFSTR("");
    if(mPassword != nil){
        password = (__bridge CFStringRef) mPassword;
    }
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12Data, options, &items);
    
    if (securityError == 0) {
        CFDictionaryRef ident = CFArrayGetValueAtIndex(items,0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(ident, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
    }
    
    if (options) {
        CFRelease(options);
    }
    
    return securityError;
}
@end

