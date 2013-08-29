//
//  SampleUIViewController.h
//  NetworkHandler
//
//  Copyright (c) 2013 Sam Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MosquittoClient.h"

@interface SampleUIViewController : UIViewController<MosquittoClientDelegate> {
    MosquittoClient *mMosquittoClient;
    NSTimer *mTimer;
}

@property (readonly) MosquittoClient *mMosquittoClient;

@end
