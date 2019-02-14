//
//  NSNotificationCenter+MainThread.h
//  Portfolium
//
//  Created by John Eisberg on 6/23/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kMessageSent;
extern NSString *const kThreadSent;
extern NSString *const kArchiveSent;
extern NSString *const kDeleteArchiveSent;
extern NSString *const kCommentPosted;
extern NSString *const kEntryLiked;
extern NSString *const kEntryViewed;
extern NSString *const kUserConnected;
extern NSString *const kEntryAdded;

@interface NSNotificationCenter (MainThread)

- (void)postNotificationOnMainThread:(NSNotification *)notification;

- (void)postNotificationOnMainThreadName:(NSString *)name
                                  object:(id)object;

- (void)postNotificationOnMainThreadName:(NSString *)name object:(id)object
                                userInfo:(NSDictionary *)userInfo;

@end
