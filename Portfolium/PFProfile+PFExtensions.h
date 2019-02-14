//
//  PFProfile_PFExtensions.h
//  Portfolium
//
//  Created by John Eisberg on 12/16/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFProfile.h"

@interface PFProfile (PFExtentions)

- (BOOL)isConnected;

- (BOOL)isPending;

- (BOOL)isAwaitingAccept;

@end
