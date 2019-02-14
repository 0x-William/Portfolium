//
//  PFOrder.m
//  Portfolium
//
//  Created by John Eisberg on 12/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFOrder.h"
#import "RKObjectMapping.h"

@implementation PFOrder

+ (NSString *)endPoint; {
    
    return @"";
}

+ (NSString *)endPointWithUserId; {
    
    return @"";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"accomplishments" : @"accomplishments",
                                                   @"affiliations" : @"affiliations",
                                                   @"athletics" : @"athletics",
                                                   @"awards" : @"awards",
                                                   @"certifications" : @"certifications",
                                                   @"courses" : @"courses",
                                                   @"educations" : @"educations",
                                                   @"experiences" : @"experiences",
                                                   @"extracurriculars" : @"extracurriculars",
                                                   @"milestones" : @"milestones",
                                                   @"publications" : @"publications",
                                                   @"skills" : @"skills",
                                                   @"volunteers" : @"volunteers",
                                                   @"createdAt" : @"createdAt",
                                                   @"updatedAt" : @"updatedAt"}];
    
    return mapping;
}

@end