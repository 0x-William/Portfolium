//
//  PFAccomplishment.m
//  Portfolium
//
//  Created by John Eisberg on 11/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFAccomplishment.h"
#import "RKObjectMapping.h"

@implementation PFAccomplishment

+ (NSString *)endPoint; {
    
    return @"";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"id"   : @"accomplishmentId",
                                                   @"title" : @"title",
                                                   @"description" : @"descr",
                                                   @"date" : @"date",
                                                   @"created_at" : @"createdAt",
                                                   @"updated_at" : @"updatedAt"}];
    
    return mapping;
}

@end