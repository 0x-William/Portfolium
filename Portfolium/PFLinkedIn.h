//
//  PFLinkedIn.h
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFOAuthTypes.h"

@interface PFLinkedIn : NSObject<PFOAuthDelegate>

+ (PFLinkedIn *)shared;

- (void)initializeLinkedIn;

@end
