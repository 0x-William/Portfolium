//
//  PFLocationProvider.m
//  Portfolium
//
//  Created by John Eisberg on 10/4/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFLocationProvider.h"
#import "NSString+PFExtensions.h"

static const NSInteger kMaxAge = 5.0;

@interface PFLocationProvider ()

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, copy) void (^locationProviderCallbackBlock)(NSString *);

@end

@implementation PFLocationProvider

+ (PFLocationProvider *)shared; {
    
    static dispatch_once_t once;
    static PFLocationProvider *shared;
    
    dispatch_once(&once, ^{
        
        shared = [[PFLocationProvider alloc] init];
        
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:shared];
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [shared setLocationManager:locationManager];
    });
    
    return shared;
}

- (void)alert; {
    
    if ([CLLocationManager locationServicesEnabled]) {
        SEL selector = NSSelectorFromString(@"requestWhenInUseAuthorization");
        if ([[self locationManager] respondsToSelector:selector]) {
            [[self locationManager] requestWhenInUseAuthorization];
        } else {
            [[self locationManager] startUpdatingLocation];
        }
    }
}

- (void)startUpdatingLocation:(void(^)(NSString *))callbackBlock; {
    
    [self setLocationProviderCallbackBlock:callbackBlock];
    
    [[self locationManager] startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [[self locationManager] startUpdatingLocation];
    } else if (status == kCLAuthorizationStatusAuthorized) {
        [[self locationManager] startUpdatingLocation];
    } else if (status > kCLAuthorizationStatusNotDetermined) {
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations; {
    
    [[self locationManager] stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(),^ {
                           
                           CLPlacemark *place = [placemarks objectAtIndex:0];
                           
                           NSString *placeName;
                           if(![NSString isNullOrEmpty:[place subLocality]]) {
                               placeName = [place locality];
                           } else {
                               placeName = [place name];
                           }
                           
                           if([self locationProviderCallbackBlock]) {
                               [self locationProviderCallbackBlock](placeName);
                           }
                       });
                   }];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    
    if (locationAge > kMaxAge) return;
    
    [[self locationManager] stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error; {
    
    [[self locationManager] stopUpdatingLocation];
}

@end
