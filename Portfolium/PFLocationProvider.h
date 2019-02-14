//
//  PFLocationProvider.h
//  Portfolium
//
//  Created by John Eisberg on 10/4/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PFLocationProvider : NSObject<CLLocationManagerDelegate>

+ (PFLocationProvider *)shared;

- (void)alert;

- (void)startUpdatingLocation:(void(^)(NSString *))callbackBlock;

@end