//
//  NSNotificationCenter+MainThread.m
//  Portfolium
//
//  Created by John Eisberg on 6/23/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "NSNotificationCenter+MainThread.h"

NSString *const kMessageSent = @"kMessageSent";
NSString *const kThreadSent = @"kThreadSent";
NSString *const kArchiveSent = @"kArchiveSent";
NSString *const kDeleteArchiveSent = @"kDeleteArchiveSent";
NSString *const kCommentPosted = @"kCommentPosted";
NSString *const kEntryLiked = @"kEntryLiked";
NSString *const kEntryViewed = @"kEntryViewed";
NSString *const kUserConnected = @"kUserConnected";
NSString *const kEntryAdded = @"kEntryAdded";

@implementation NSNotificationCenter (MainThread)

- (void)postNotificationOnMainThread:(NSNotification *)notification {
    
    [self performSelectorOnMainThread:@selector(postNotification:)
                           withObject:notification
                        waitUntilDone:YES];
}

- (void)postNotificationOnMainThreadName:(NSString *)name
                                  object:(id)object {
    
    NSNotification *notification = [NSNotification notificationWithName:name
                                                                 object:object];
	[self postNotificationOnMainThread:notification];
}

- (void)postNotificationOnMainThreadName:(NSString *)name
                                  object:(id)object
                                userInfo:(NSDictionary *)userInfo {
	
    NSNotification *notification = [NSNotification notificationWithName:name
                                                                 object:object
                                                               userInfo:userInfo];
	[self postNotificationOnMainThread:notification];
}

@end