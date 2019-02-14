//
//  PFAbout.m
//  Portfolium
//
//  Created by John Eisberg on 11/26/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFAbout.h"
#import "RKObjectMapping.h"

@implementation PFAbout

+ (NSString *)endPoint; {
    
    return @"";
}

+ (NSString *)endPointWithUserId; {
    
    return @"/users/about/:user_id";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"user_id" : @"userId" }];
    
    return mapping;
}

- (NSString *)endPointWithUserIdPath; {
    
    return [[PFAbout endPointWithUserId] stringByReplacingOccurrencesOfString:@":user_id"
                                                                   withString:[[self userId] stringValue]];
}

- (NSInteger)numberOfItems; {
    
    NSInteger numberOfItems = 0;
    
    if([[self interests] count] != 0) {
        numberOfItems += [[self interests] count] + 1;
    }
    
    if([[self accomplishments] count] != 0) {
        numberOfItems += [[self accomplishments] count] + 1;
    }
    
    if([[self affiliations] count] != 0) {
        numberOfItems += [[self accomplishments] count] + 1;
    }
    
    if([[self athletics] count] != 0) {
        numberOfItems += [[self athletics] count] + 1;
    }
    
    if([[self awards] count] != 0) {
        numberOfItems += [[self awards] count] + 1;
    }
    
    if([[self certifications] count] != 0) {
        numberOfItems += [[self certifications] count] + 1;
    }
    
    if([[self courses] count] != 0) {
        numberOfItems += [[self courses] count] + 1;
    }
    
    if([[self educations] count] != 0) {
        numberOfItems += [[self educations] count] + 1;
    }
    
    if([[self experiences] count] != 0) {
        numberOfItems += [[self experiences] count] + 1;
    }
    
    if([[self extracurriculars] count] != 0) {
        numberOfItems += [[self extracurriculars] count] + 1;
    }
    
    if([[self milestones] count] != 0) {
        numberOfItems += [[self milestones] count] + 1;
    }
    
    if([[self publications] count] != 0) {
        numberOfItems += [[self publications] count] + 1;
    }
    
    if([[self skills] count] != 0) {
        numberOfItems += [[self skills] count] + 1;
    }
    
    if([[self volunteers] count] != 0) {
        numberOfItems += [[self volunteers] count] + 1;
    }
    
    return numberOfItems;
}

@end
