//
//  PFCount.m
//  Portfolium
//
//  Created by John Eisberg on 12/18/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFCount.h"
#import "RKObjectMapping.h"

@implementation PFCount

+ (NSString *)endPoint; {
    
    return @"/notifications/counts";
}

+ (NSString *)endPointWithUserId; {
    
    return @"";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"notifications" : @"notifications",
                                                   @"messages" : @"messages",
                                                   @"entries" : @"entries" }];
    
    return mapping;
}

@end