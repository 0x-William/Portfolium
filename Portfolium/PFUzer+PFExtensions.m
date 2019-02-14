//
//  PFUzer+PFExtensions.m
//  Portfolium
//
//  Created by John Eisberg on 12/17/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFUzer+PFExtensions.h"
#import "PFStatus.h"

@implementation PFUzer (PFExtentions)

- (BOOL)isConnected; {
    
    return [[self connected] integerValue] > 0;
}

- (BOOL)isPending; {
    
    return [[[self status] status] isEqualToString:kPending]
    && [[self status] token] == nil;
}

- (BOOL)isAwaitingAccept; {
    
    return [[self status] token] != nil;
}

@end