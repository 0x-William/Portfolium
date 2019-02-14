//
//  PFMedia.m
//  Portfolium
//
//  Created by John Eisberg on 8/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFMedia.h"
#import "RKObjectMapping.h"

@implementation PFMedia

+ (NSString *)endPoint; {
    
    return @"";
}

+ (NSString *)endPointWithId; {
    
    return @"/entries/media/:mediaId";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"created_at" : @"createdAt",
                                                   @"default" : @"dfault",
                                                   @"deleted" : @"deleted",
                                                   @"fk_entry_id" : @"entryId",
                                                   @"height" : @"height",
                                                   @"id" : @"mediaId",
                                                   @"updated_at" : @"updatedAt",
                                                   @"video" : @"video",
                                                   @"width" : @"width" }];
    
    return mapping;
}

- (NSString *)endPointWithIdPath; {
    
    if([self mediaId] == nil) {
        [self setMediaId:@0];
    }
    
    return [[PFMedia endPointWithId] stringByReplacingOccurrencesOfString:@":mediaId"
                                                               withString:[[self mediaId] stringValue]];
}

@end