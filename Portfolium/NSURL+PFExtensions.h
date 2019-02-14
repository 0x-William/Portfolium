//
//  NSURL+PFExtensions.h
//  Portfolium
//
//  Created by John Eisberg on 8/26/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSURL (PFExtensions)

- (BOOL)isProfileURL;

- (NSNumber *)getUserId;

@end
