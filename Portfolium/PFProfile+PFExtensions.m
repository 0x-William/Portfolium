//
//  PFProfile_PFExtensions.m
//  Portfolium
//
//  Created by John Eisberg on 12/16/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFProfile+PFExtensions.h"
#import "PFStatus.h"

@implementation PFProfile (PFExtentions)

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