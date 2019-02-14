//
//  PFExperience.m
//  Portfolium
//
//  Created by John Eisberg on 11/26/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFExperience.h"
#import "RKObjectMapping.h"

@implementation PFExperience

+ (NSString *)endPoint; {
    
    return @"";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"id" : @"experienceId",
                                                   @"company" : @"company",
                                                   @"position" : @"position",
                                                   @"description" : @"desc",
                                                   @"start_date" : @"startDate",
                                                   @"end_date" : @"endDate",
                                                   @"createdAt" : @"createdAt",
                                                   @"updatedAt" : @"updatedAt"}];
    return mapping;
}

@end