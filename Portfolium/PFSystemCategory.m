//
//  PFSystemCategory.m
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFSystemCategory.h"
#import "RKObjectMapping.h"

@implementation PFSystemCategory

+ (NSString *)endPoint; {
    
    return @"";
}

+ (NSString *)endPointFeed; {
    
    return @"/system/categories";
}

+ (NSString *)endPointWithCategoryId; {
    
    return @"/system/category/:id";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"category" : @"name",
                                                   @"description" : @"desc",
                                                   @"created_at" : @"createdAt",
                                                   @"id" : @"categoryId",
                                                   @"parent_id" : @"parentId",
                                                   @"interested" : @"interested",
                                                   @"hex" : @"hex" }];
    return mapping;
}

- (NSString *)endPointWithCategoryIdPath; {
    
    if([self categoryId] == nil) {
        [self setCategoryId:@0];
    }
    
    return [[PFSystemCategory endPointWithCategoryId] stringByReplacingOccurrencesOfString:@":id"
                                                                                withString:[[self categoryId] stringValue]];
}

- (NSString *)getIndexableName; {
    
    return [self name];
}

@end
