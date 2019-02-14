//
//  PFCellDescriptor.h
//  Portfolium
//
//  Created by John Eisberg on 6/21/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFCellDescriptor

+ (NSString *)preferredReuseIdentifier;

- (void) setStateFromDescriptor:(NSDictionary *)descriptor;

@end
