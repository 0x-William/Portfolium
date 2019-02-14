//
//  PFImg.m
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFImg.h"
#import "RKObjectMapping.h"

@implementation PFImg

+ (NSString *)endPoint; {
    
    return @"";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"cropped" : @"cropped",
                                                   @"cropped_https" : @"croppedHttps",
                                                   @"url" : @"url",
                                                   @"url_https" : @"urlHttps"}];
    return mapping;
}

@end