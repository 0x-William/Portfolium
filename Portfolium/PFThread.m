//
//  PFThread.m
//  Portfolium
//
//  Created by John Eisberg on 8/10/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFThread.h"
#import "RKObjectMapping.h"

@implementation PFThread

+ (NSString *)endPoint; {
    
    return @"/messages/threads";
}

+ (NSString *)createEndPoint; {
    
    return @"/messages/create";
}

+ (NSString *)endPointWithThreadId; {
    
    return @"/messages/archive/:id";
}

+ (NSString *)endPointForMessages; {
    
    return @"/messages/thread/:id";
}

+ (NSString *)endPointForUsers; {
    
    return @"/messages/users/:id";
}

+ (NSString *)endPointForReply; {
    
    return @"/messages/reply/:id";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{ @"id" : @"threadId",
                                                   @"fk_last_user_id" : @"lastUserId",
                                                   @"last_body" : @"lastBody",
                                                   @"subject" : @"subject",
                                                   @"archived" : @"archived",
                                                   @"created_at" : @"createdAt",
                                                   @"updated_at" : @"updatedAt",
                                                   @"read_at" : @"readAt",
                                                   @"previous_thread_id" : @"previousThreadId",
                                                   @"next_thread_id" : @"nextThreadId"}];
    
    return mapping;
}

- (NSString *)pathWithThreadId; {
    
    return [NSString stringWithFormat:@"%@/%@", @"/messages/archive", [self threadId]];
}

- (NSString *)messagesWithThreadId; {
    
    return [NSString stringWithFormat:@"%@/%@", @"/messages/thread", [self threadId]];
}

- (NSString *)usersWithThreadId; {
    
    return [NSString stringWithFormat:@"%@/%@", @"/messages/users", [self threadId]];
}

- (NSString *)replyWithThreadId; {
    
    return [NSString stringWithFormat:@"%@/%@", @"/messages/reply", [self threadId]];
}

- (NSString *)toString; {
    
    return @"";
}

@end