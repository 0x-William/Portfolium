//
//  PFSchool.m
//  Portfolium
//
//  Created by John Eisberg on 7/30/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFSchool.h"
#import "RKObjectMapping.h"

@implementation PFSchool

+ (NSString *)endPoint; {
    
    return @"";
}

+ (NSString *)endPointHighSchool; {
    
    return @"/system/highschools";
}

+ (NSString *)endPointCommunityCollege; {
    
    return @"/system/communityColleges";
}

+ (NSString *)endPointCollege; {
    
    return @"/system/universities";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"name" : @"name" }];
    
    return mapping;
}

- (NSString *)getIndexableName; {
    
    return [self name];
}

@end
