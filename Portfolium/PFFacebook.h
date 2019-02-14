//
//  PFFacebook.h
//  Portfolium
//
//  Created by John Eisberg on 6/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFOAuthTypes.h"

@interface PFFacebook : NSObject<PFOAuthDelegate>

+ (PFFacebook *)shared;

@end
