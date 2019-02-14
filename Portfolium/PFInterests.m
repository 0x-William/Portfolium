//
//  PFInterests.m
//  Portfolium
//
//  Created by John Eisberg on 8/1/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFInterests.h"
#import "RKObjectMapping.h"
#import "NSString+PFExtensions.h"

@implementation PFInterests

+ (NSString *)endPoint; {
    
    return @"/users/interests";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"categoryIds" : @"categoryIds" }];
    
    return mapping;
}

- (NSMutableDictionary *) categoryIdsToDictionary; {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSNumber *categoryId;
    NSString *commaDelimited = [NSString empty];
    NSString *delimiter = [NSString empty];
    
    for(int i = 0; i < [[self categoryIds] count]; i++) {
        
        categoryId = [[self categoryIds] objectAtIndex:i];
        commaDelimited = [NSString stringWithFormat:@"%@%@%@", commaDelimited, delimiter, categoryId];
        delimiter = @",";
    }
    
    [dictionary setObject:commaDelimited forKey:@"category_ids"];
    
    return dictionary;
}

@end
