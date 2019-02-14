//
//  PFUzer+PFExtensions.h
//  Portfolium
//
//  Created by John Eisberg on 12/17/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFUzer.h"

@interface PFUzer (PFExtentions)

- (BOOL)isConnected;

- (BOOL)isPending;

- (BOOL)isAwaitingAccept;

@end