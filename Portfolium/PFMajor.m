//
//  PFMajor.m
//  Portfolium
//
//  Created by John Eisberg on 7/30/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFMajor.h"
#import "RKObjectMapping.h"

@implementation PFMajor

+ (NSString *)endPoint; {
    
    return @"/system/majors";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"major" : @"name" }];
    
    return mapping;
}

- (NSString *)getIndexableName; {
    
    return [self name];
}

@end
