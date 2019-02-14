//
//  PFProfile.m
//  Portfolium
//
//  Created by John Eisberg on 8/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFProfile.h"
#import "RKObjectMapping.h"

@implementation PFProfile

+ (NSString *)endPoint; {
    
    return @"";
}

+ (NSString *)endPointSearch; {
    
    return @"/search/users";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"id" : @"userId",
                                                   @"firstname" : @"firstname",
                                                   @"lastname" : @"lastname",
                                                   @"username" : @"username",
                                                   @"school" : @"school",
                                                   @"major" : @"major",
                                                   @"connected" : @"connected" }];
    
    return mapping;
}

@end