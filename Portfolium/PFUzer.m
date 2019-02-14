//
//  PFUser.m
//  Portfolium
//
//  Created by John Eisberg on 6/12/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFUzer.h"
#import "RKObjectMapping.h"

@implementation PFUzer

+ (NSString *)endPoint; {
    
    return @"/users/me";
}

+ (NSString *)endPointFacebook; {
    
    return @"/auth/facebook";
}

+ (NSString *)endPointTwitter; {
    
    return @"/auth/twitter";
}

+ (NSString *)endPointLinkedIn; {
    
    return @"/auth/linkedIn";
}

+ (NSString *)endPointJoin; {
    
    return @"/auth/join";
}

+ (NSString *)endPointLogin; {
    
    return @"/auth/login";
}
+ (NSString *)endPointForgotPassword; {
    
    return @"/auth/forgot";
}

+ (NSString *)endPointFeed; {
    
    return @"/users/feed";
}

+ (NSString *)endPointSuggested; {
    
    return @"/users/suggestions";
}

+ (NSString *)endPointConnections; {
    
    return @"/connections/user/:userId";
}

+ (NSString *)endPointWithId; {
 
    return @"/users/user/:userId";
}

+ (NSString *)endPointConnect; {
    
    return @"/connections/request/:userId";
}

+ (NSString *)endPointConnectionAccept; {
    
    return @"/connections/accept/:token";
}

+ (NSString *)endPointEmailNotification; {
   
   return @"/users/email_notification";
}

+ (NSString *)endPointChangePassword; {
 
    return @"/users/password";
}

+ (NSString *)endPointChangeEmail; {
    
    return @"/users/email";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"id" : @"userId",
                                                   @"email" : @"email",
                                                   @"username": @"username",
                                                   @"firstname" : @"firstname",
                                                   @"lastname" : @"lastname",
                                                   @"password" : @"password",
                                                   @"points" : @"points",
                                                   @"percent" : @"percent",
                                                   @"type" : @"type",
                                                   @"views" : @"views",
                                                   @"token" : @"token",
                                                   @"avatar_url" : @"avatarUrl",
                                                   @"cover_url" : @"coverUrl",
                                                   @"tagline" : @"tagline",
                                                   @"location" : @"location",
                                                   @"gender" : @"gender",
                                                   @"birthday" : @"birthday",
                                                   @"phone" : @"phone",
                                                   @"linkedin_id" : @"linkedInId",
                                                   @"linkedin_url" : @"linkedInUrl",
                                                   @"facebook_token" : @"facebookToken",
                                                   @"resume" : @"resume",
                                                   @"student_id" : @"studentId",
                                                   @"school_badge_url" : @"schoolBadgeUrl",
                                                   @"privacy" : @"privacy",
                                                   @"email_comment" : @"emailComment",
                                                   @"email_like" : @"emailLike",
                                                   @"email_tag" : @"emailTag",
                                                   @"email_message" : @"emailMessage",
                                                   @"email_network" : @"emailNetwork",
                                                   @"email_employer" : @"emailEmployer",
                                                   @"created_at" : @"createdAt",
                                                   @"updated_at" : @"updatedAt",
                                                   @"onboarded" : @"onboarded",
                                                   @"connected" : @"connected",
                                                   @"school" : @"school",
                                                   @"major" : @"major" }];
    return mapping;
}

- (NSString *)endPointWithIdPath; {
    
    if([self userId] == nil) {
        [self setUserId:@0];
    }
    
    return [[PFUzer endPointWithId] stringByReplacingOccurrencesOfString:@":userId"
                                                              withString:[[self userId] stringValue]];
}

- (NSString *)endPointConnectionsPath; {
    
    if([self userId] == nil) {
        [self setUserId:@0];
    }
    
    return [[PFUzer endPointConnections] stringByReplacingOccurrencesOfString:@":userId"
                                                                   withString:[[self userId] stringValue]];
}

- (NSString *)endPointConnectPath; {
    
    if([self userId] == nil) {
        [self setUserId:@0];
    }
    
    return [[PFUzer endPointConnect] stringByReplacingOccurrencesOfString:@":userId"
                                                               withString:[[self userId] stringValue]];
}

- (NSString *)endPointConnectionAcceptPath; {
    
    if([self token] == nil) {
        [self setToken:@"0"];
    }
    
    return [[PFUzer endPointConnectionAccept] stringByReplacingOccurrencesOfString:@":token"
                                                                        withString:[self token]];
}

@end