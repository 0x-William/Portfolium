//
//  PFToken.m
//  Portfolium
//
//  Created by John Eisberg on 6/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFToken.h"
#import "RKObjectMapping.h"

@implementation PFToken

+ (NSString *)endPoint; {
    
    return @"";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"token" : @"token",
                                                   @"source" : @"source",
                                                   @"fk_user_id" : @"fkUserId",
                                                   @"fk_key_id" : @"fkKeyId",
                                                   @"created_at" : @"createdAt"}];
    return mapping;
}

@end
