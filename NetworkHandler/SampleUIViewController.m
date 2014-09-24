//
//  SampleUIViewController.m
//  NetworkHandler
//
//  Copyright (c) 2013 Sam Wang. All rights reserved.
//

#import "SampleUIViewController.h"

#import "HttpResponse.h"
#import "HttpHeader.h"
#import "NetworkHandler.h"

@interface SampleUIViewController ()

@end

@implementation SampleUIViewController

@synthesize mMosquittoClient;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Sample webpage retrieve behavior
//    [self performSelectorInBackground:@selector(doNetworkStuff) withObject:nil];
    
    // Init MQTT client (without SSL)
    //[self mqttInit:@"127.0.0.1" withPort:1883];
    
    // Init MQTT client (with SSL)
//    [self mqttInitWithSSL:@"10.70.1.81" withPort:8883];
    
    // SSDP device receiver
//    mSSDPSock = [[SSDPSocket alloc] init];
//    mSSDPSock.delegate = self;
//    [mSSDPSock initSSDPSocket];
//    [mSSDPSock sendSearchRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc
{
    if(mSSDPSock != nil){
        [mSSDPSock closeSSDPSocket];
        mSSDPSock = nil;
    }
    
    if(mMosquittoClient != nil){
        [mMosquittoClient disconnect];
        [mMosquittoClient clearMosquittoLib];
        mMosquittoClient = nil;
    }
}

- (void) doNetworkStuff
{
    HttpHeader *header = [[HttpHeader alloc] init];
    [header setHeader:HTTP_HOST value:@"www.google.com"];
    [header setHeader:HTTP_ACCEPT value:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"];
    [header setHeader:HTTP_CONNECTION value:@"keep-alive"];
    [header setHeader:HTTP_USER_AGENT value:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.57 Safari/537.36"];
    
    HttpResponse *response = [NetworkHandler httpAction:@"https://www.google.com" method:HTTP_GET withData:nil header:header withDelegate:nil];
    NSLog(@"Resposne status=%d", [response mStatusCode]);
    NSLog(@"Resposne body=%@", [[response mResponse] substringToIndex:100]);
}

#pragma mark SSDP parts
- (void) didReceiveDevices: (SSDPDevice *)device
{
    NSLog(@"----- didReceiveDevices ------");
    NSLog(@"FriendlyName= \t\t%@", [device mFriendlyName]);
    NSLog(@"SerialNumber= \t\t%@", [device mSerialNumber]);
    NSLog(@"DeviceType= \t\t%@", [device mDeviceType]);
    NSLog(@"ModelDescription= \t%@", [device mModelDescription]);
    NSLog(@"UDN= \t\t\t%@", [device mUDN]);
    for(SSDPDeviceService *service in [device mServiceList]){
        NSLog(@"EventSubURL= \t\t%@", [service mEventSubURL]);
        NSLog(@"ServiceType= \t\t%@", [service mServiceType]);
    }
}

#pragma mark MQTT parts
- (void) mqttInit:(NSString *)host withPort:(int)port
{
    // mosquitto ssl client connection
    NSString *clientId = @"marquette_sample";
	NSLog(@"Client ID: %@", clientId);
    mMosquittoClient = [[MosquittoClient alloc] initWithClientId:clientId];
    [mMosquittoClient setDelegate:self];
    [mMosquittoClient setHost:host];
    [mMosquittoClient setPort:port];
	[mMosquittoClient connect];
}

- (void) mqttInitWithSSL:(NSString *)host withPort:(int)port
{    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *caCrtFile = [mainBundle pathForResource: @"ca" ofType: @"crt"];
    NSLog(@"caCrtFile=%@", caCrtFile);
    const char *caCrt = [caCrtFile cStringUsingEncoding:NSASCIIStringEncoding];

    NSString *clientCrtFile = [mainBundle pathForResource: @"client" ofType: @"crt"];
    const char *clientCrt = [clientCrtFile cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSString *clientKeyFile = [mainBundle pathForResource: @"client" ofType: @"key"];
    const char *clientKey = [clientKeyFile cStringUsingEncoding:NSASCIIStringEncoding];
    
    // mosquitto ssl client connection
    NSString *clientId = @"marquette_sample";
	NSLog(@"Client ID: %@", clientId);
    mMosquittoClient = [[MosquittoClient alloc] initWithClientId:clientId];
    [mMosquittoClient setDelegate:self];
    [mMosquittoClient setHost:host];
    [mMosquittoClient setPort:port];
    [MosquittoClient setClientPassword:@"client"];
    [mMosquittoClient connectWithSSL:TLSV1 caCrt:caCrt caLocation:NULL clientCrt:clientCrt clientKey:clientKey];
}

- (void) mqttSubscribe:(NSString *)topic withQos:(int)qos
{
    if(nil != mMosquittoClient){
        [mMosquittoClient subscribe:topic withQos:qos];
    }
}

- (void) mqttPublish:(NSString *)topic withMessage:(NSString *)message withQos:(int)qos;
{
    if(nil != mMosquittoClient){
        NSUInteger nsQos = qos;
        [mMosquittoClient publishString:message toTopic:topic withQos:nsQos retain:YES];
    }
}

- (void) mqttDisconnect
{
    if(nil != mMosquittoClient){
        [mMosquittoClient disconnect];
    }
}

- (void) mqttReconnect
{
    NSLog(@"mqttReconnect");
    if(nil != mMosquittoClient){
        [mMosquittoClient reconnect];
    }
}

// Mosquitto callback listener
- (void) didConnect:(NSUInteger)code
{
	NSLog(@"mosquitto didConnect");
    if(mTimer != nil){
        [mTimer invalidate];
        mTimer = nil;
    }
    [self mqttSubscribe:@"test" withQos:1];
    //[self mqttPublish:@"test" withMessage:@"sample string" withQos:1];
}

- (void) didDisconnect
{
	NSLog(@"mosquitto didDisconnect");
    //[mMosquittoClient clearMosquittoLib];
    
    mTimer = [NSTimer scheduledTimerWithTimeInterval:10 // 10sec
                                             target:self
                                            selector:@selector(mqttReconnect)
                                           userInfo:nil
                                            repeats:YES];
    
}

- (void) didReceiveMessage:(MosquittoMessage*) mosq_msg
{
	NSLog(@"%@ => %@", mosq_msg.topic, mosq_msg.payload);
}

- (void) didPublish: (NSUInteger)messageId {}
- (void) didSubscribe: (NSUInteger)messageId grantedQos:(NSArray*)qos {}
- (void) didUnsubscribe: (NSUInteger)messageId {}



@end
