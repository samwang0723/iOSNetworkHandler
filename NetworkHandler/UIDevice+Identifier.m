//
//  UIDevice+Identifier.m
//  I.C.E
//
//  Created by Blackloud iOS team on 11/25/13.
//  Copyright (c) 2013 Blackloud iOS team. All rights reserved.
//

#import "UIDevice+Identifier.h"

@implementation UIDevice (Identifier)

- (NSString *) identifierForVendor1
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return @"";
}

@end
