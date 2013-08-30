//
//  SSDPSocket.h
//  SSDPScoket
//
//  Created by Mike on 1/11/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"

#define SSDP_BROADCAST_ADDRESS @"239.255.255.250"
#define SSDP_BROADCAST_PORT    1900

extern NSString *const SSDP_FOUND_DEVICES_NOTIFY;
extern NSString *const SSDP_TORPEDO_DEVICE;
extern NSString *const SSDP_TORPEDO_DEVICE_NAME;
extern NSString *const SSDP_TORPEDO_DEVICE_ADDRESS;

@interface SSDPSocket : NSObject{
    GCDAsyncUdpSocket *udpSocket;
}

-(void) initSSDPSocket;
-(void) sendSearchRequest;
-(void) closeSSDPSocket;

@end
