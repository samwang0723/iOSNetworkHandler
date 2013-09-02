//
//  SampleUIViewController.h
//  NetworkHandler
//
//  Copyright (c) 2013 Sam Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MosquittoClient.h"
#import "SSDPSocket.h"

@interface SampleUIViewController : UIViewController<MosquittoClientDelegate, SSDPDelegate> {
    MosquittoClient *mMosquittoClient;
    SSDPSocket *mSSDPSock;
    NSTimer *mTimer;
}

@property (readonly) MosquittoClient *mMosquittoClient;

@end
