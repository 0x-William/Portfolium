//
//  PFListCategory.m
//  Portfolium
//
//  Created by John Eisberg on 11/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFListCategory.h"
#import "RKObjectMapping.h"

@implementation PFListCategory

+ (NSString *)endPoint; {
    
    return @"";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"id"   : @"listCategoryId",
                                                   @"category" : @"name",
                                                   @"slug" : @"slug",
                                                   @"parent_id" : @"parentId",
                                                   @"description" : @"desc",
                                                   @"created_at" : @"createdAt",
                                                   @"parent_slug" : @"parentSlug",
                                                   @"category" : @"name",
                                                   @"category" : @"name"}];
    
    return mapping;
}

@end