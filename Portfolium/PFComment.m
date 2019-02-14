//
//  PFComment.m
//  Portfolium
//
//  Created by John Eisberg on 8/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFComment.h"
#import "RKObjectMapping.h"

@implementation PFComment

+ (NSString *)endPoint; {
    
    return @"";
}

+ (NSString *)endPointWithEntryId; {
    
    return @"/entries/comments/:fk_entry_id";
}

+ (NSString *)endPointCreateWithEntryId; {
    
    return @"/entries/comment/:fk_entry_id";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"comment" : @"comment",
                                                   @"fk_entry_id" : @"entryId",
                                                   @"fk_user_id" : @"userId",
                                                   @"id" : @"commentId",
                                                   @"created_at" : @"createdAt",
                                                   @"updated_at" : @"updatedAt" }];
    
    return mapping;
}

- (NSString *)endPointWithEntryIdPath; {
    
    if([self entryId] == nil) {
        [self setEntryId:@0];
    }
    
    return [[PFComment endPointWithEntryId] stringByReplacingOccurrencesOfString:@":fk_entry_id"
                                                                      withString:[[self entryId] stringValue]];
}

- (NSString *)endPointCreateWithEntryIdPath; {
    
    if([self entryId] == nil) {
        [self setEntryId:@0];
    }
    
    return [[PFComment endPointCreateWithEntryId] stringByReplacingOccurrencesOfString:@":fk_entry_id"
                                                                            withString:[[self entryId] stringValue]];
}

@end