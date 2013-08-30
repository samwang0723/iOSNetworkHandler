//
//  SSDPSocket.m
//  SSDPScoket
//
//  Created by Mike on 1/11/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import "SSDPSocket.h"

@implementation SSDPSocket

NSString *const SSDP_FOUND_DEVICES_NOTIFY = @"SSDP_FOUND_DEVICES";
NSString *const SSDP_TORPEDO_DEVICE = @"SSDP_TORPEDO_DEVICE";
NSString *const SSDP_TORPEDO_DEVICE_NAME = @"SSDP_TORPEDO_DEVICE_NAME";
NSString *const SSDP_TORPEDO_DEVICE_ADDRESS = @"SSDP_TORPEDO_DEVICE_ADDRESS";

- (void)initSSDPSocket
{    
	udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	
	NSError *error = nil;

    [udpSocket enableBroadcast:TRUE error:nil];
	if (![udpSocket bindToPort:SSDP_BROADCAST_PORT error:&error])
	{
		NSLog(@"Error binding: %@", error);
		return;
	}
	if (![udpSocket beginReceiving:&error])
	{
		NSLog(@"Error receiving: %@", error);
		return;
	}
    if (![udpSocket joinMulticastGroup:SSDP_BROADCAST_ADDRESS error:&error])
    {
        NSLog(@"Error joinMulticastGroup: %@", [error localizedDescription]);
		return;
    }
    
    NSLog(@"SSDP init Ready");
}

-(void) closeSSDPSocket{
    [udpSocket close];
}

-(void)sendSearchRequest{
    NSString *search = @"M-SEARCH * HTTP/1.1\r\nHost:239.255.255.250:1900\r\nMan: \"ssdp:discover\"\r\nST:urn:schemas-upnp-org:service:Torpedo:1\r\nMX:3\r\n\r\n";
    [udpSocket sendData:[search dataUsingEncoding:NSUTF8StringEncoding]
                      toHost: SSDP_BROADCAST_ADDRESS port: SSDP_BROADCAST_PORT withTimeout:-1 tag:1];
    [udpSocket joinMulticastGroup:SSDP_BROADCAST_ADDRESS error:nil];
    [udpSocket bindToPort:SSDP_BROADCAST_PORT error:nil];
    [udpSocket beginReceiving:nil];
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
        fromAddress:(NSData *)address
        withFilterContext:(id)filterContext{
	NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if (msg){
        NSArray *response = [msg componentsSeparatedByString:@"\r\n"];
        if([self isWantSSDPResponse:response]){
            [self handleResponseMessage:response];
        };
	}else{
		NSString *host = nil;
		uint16_t port = 0;
		[GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
		
		NSLog(@"RECV: Unknown message from: %@:%hu", host, port);
	}
}

-(BOOL)isWantSSDPResponse: (NSArray *)response{
    if([response count]<7){
        return NO;
    }
    NSString *responseType = [response objectAtIndex:6];
    NSString *target = @"ST:urn:schemas-upnp-org:service:Torpedo:1";
    if([responseType isEqualToString:target]){
        return YES;
    }else{
        return NO;
    }
}

-(void) handleResponseMessage: (NSArray *) response{
    NSString *address = [[response objectAtIndex:4] substringFromIndex:9];
    NSString *deviceName = [[response objectAtIndex:5] substringFromIndex:7];
    NSLog(@"address:%@", address);
    NSLog(@"device name:%@", deviceName);

    [self sendGotDevicesNotification:deviceName address:address];
}

-(void) sendGotDevicesNotification:(NSString *) deviceName address:(NSString *) address{
    
    NSString *deviceString = @"";
    deviceString = [deviceString stringByAppendingFormat:@"%@ - %@", deviceName, address];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:deviceString, SSDP_TORPEDO_DEVICE, deviceName, SSDP_TORPEDO_DEVICE_NAME, address, SSDP_TORPEDO_DEVICE_ADDRESS, nil];
    NSNotification *notify = [NSNotification notificationWithName:SSDP_FOUND_DEVICES_NOTIFY object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:GOT_DEVICES object:self];
}

@end
