//
//  PFNotification.m
//  Portfolium
//
//  Created by John Eisberg on 8/18/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFNotification.h"
#import "RKObjectMapping.h"

@implementation PFNotification

+ (NSString *)endPoint; {
    
    return @"/notifications/feed";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"id" : @"notificationId",
                                                   @"fk_user_id" : @"userId",
                                                   @"notification" : @"notification",
                                                   @"type" : @"type",
                                                   @"object_id"
                                                   @"label" : @"label",
                                                   @"description" : @"desc",
                                                   @"image" : @"image",
                                                   @"seen" : @"seen",
                                                   @"created_at" : @"createdAt",
                                                   @"updated_at" : @"updatedAt" }];
    
    return mapping;
}

+ (NSString *)endPointSeen; {
    
    return @"/notifications/seen/:id";
}

- (NSString *)endPointSeenPath; {
    
    if([self notificationId] == nil) {
        [self setNotificationId:@0];
    }
    
    return [[PFNotification endPointSeen] stringByReplacingOccurrencesOfString:@":id"
                                                                    withString:[[self notificationId] stringValue]];
}

@end