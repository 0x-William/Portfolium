//
//  PFMessage.m
//  Portfolium
//
//  Created by John Eisberg on 8/11/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFMessage.h"
#import "RKObjectMapping.h"

@implementation PFMessage

+ (NSString *)endPoint; {
    
    return @"";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"id" : @"messageId",
                                                   @"fk_thread_id" : @"threadId",
                                                   @"fk_author_id" : @"userId",
                                                   @"body" : @"body",
                                                   @"read_at" : @"readAt",
                                                   @"created_at": @"createdAt" }];
    
    return mapping;
}

@end