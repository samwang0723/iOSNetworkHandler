//
//  AppDelegate.h
//  NetworkHandler
//
//  Copyright (c) 2013 Sam Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleUIViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    SampleUIViewController *viewController;
}
@property (strong, nonatomic) SampleUIViewController *viewController;
@property (strong, nonatomic) UIWindow *window;

@end
