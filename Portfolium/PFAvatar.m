//
//  PFAvatar.m
//  Portfolium
//
//  Created by John Eisberg on 8/10/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFAvatar.h"
#import "RKObjectMapping.h"

@implementation PFAvatar

+ (NSString *)endPoint; {
    
    return @"";
}

+ (NSString *)endPointCreate; {
    
    return @"/users/avatar";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"dynamic" : @"dynamic",
                                                   @"dynamic_https" : @"dynamicHttps",
                                                   @"url" : @"url",
                                                   @"url_https" : @"urlHttps" }];
    
    return mapping;
}

@end