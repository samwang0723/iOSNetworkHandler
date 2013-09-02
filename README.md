iOSNetworkHandler
=================

Handler for network related retrieve behavior, such as HTTP/HTTPS

Example:

[HTTP/HTTPS webpage retrieve]

	- (void) doNetworkStuff
	{
    	HttpHeader *header = [[HttpHeader alloc] init];
    	[header setHeader:HTTP_HOST value:@"www.google.com"];
    	[header setHeader:HTTP_ACCEPT value:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"];
    	[header setHeader:HTTP_CONNECTION value:@"keep-alive"];
    	[header setHeader:HTTP_USER_AGENT value:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.57 Safari/537.36"];
    
    	HttpResponse *response = [NetworkHandler get:@"https://www.google.com" withData:nil withSSL:YES header:header];
    	NSLog(@"Resposne status=%d", [response getMStatusCode]);
    	NSLog(@"Resposne body=%@", [response getMResponse]);
	}

[MQTT client with SSL/TLS]

Based on https://github.com/njh/marquette, I modified the SSL parts to make developers can easily change different SSL certificates and passwords.
Please refer to SampleUIViewController.h

	// Init MQTT client (without SSL)
    [self mqttInit:@"127.0.0.1" withPort:1883];
    
    // Init MQTT client (with SSL)
    [self mqttInitWithSSL:@"127.0.0.1" withPort:8883];
    
    [self mqttSubscribe:@"test" withQos:1];
    [self mqttPublish:@"test" withMessage:@"sample string" withQos:1];
    
[SSDP alive devices]

Based on https://github.com/robbiehanson/CocoaAsyncSocket, I create three structures 1) SSDPDevice 2) SSDPDeviceIcon 3) SSDPDeviceService to store the information from SSDP alive devices. 

Developers who wants to retrieve them immediately, please implements the SSDPDelegate.

    // SSDP device receiver
    mSSDPSock = [[SSDPSocket alloc] init];
    mSSDPSock.delegate = self;
    [mSSDPSock initSSDPSocket];
    [mSSDPSock sendSearchRequest];

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
