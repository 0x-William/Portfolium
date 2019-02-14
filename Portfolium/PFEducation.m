//
//  PFEducation.m
//  Portfolium
//
//  Created by John Eisberg on 11/26/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFEducation.h"
#import "RKObjectMapping.h"

@implementation PFEducation

+ (NSString *)endPoint; {
    
    return @"";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"id" : @"educationId",
                                                   @"school" : @"school",
                                                   @"major" : @"major",
                                                   @"grad_year" : @"gradYear",
                                                   @"gpa" : @"gpa",
                                                   @"description" : @"desc",
                                                   @"current" : @"current",
                                                   @"createdAt" : @"createdAt",
                                                   @"updatedAt" : @"updatedAt"}];
    
    return mapping;
}

@end