//
//  PFAffiliation.m
//  Portfolium
//
//  Created by John Eisberg on 11/26/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFAffiliation.h"
#import "RKObjectMapping.h"

@implementation PFAffiliation

+ (NSString *)endPoint; {
    
    return @"";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"id"   : @"accomplishmentId",
                                                   @"title" : @"title",
                                                   @"description" : @"descr",
                                                   @"start_date": @"startDate",
                                                   @"end_date": @"endDate",
                                                   @"created_at" : @"createdAt",
                                                   @"updated_at" : @"updatedAt"}];
    
    return mapping;
}

@end
