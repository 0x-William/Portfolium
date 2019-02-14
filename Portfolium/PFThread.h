//
//  PFThread.h
//  Portfolium
//
//  Created by John Eisberg on 8/10/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"

@class PFProfile;
@class PFMessage;

@interface PFThread : NSObject<PFModel>

@property(nonatomic, strong) NSNumber *threadId;
@property(nonatomic, strong) NSNumber *lastUserId;
@property(nonatomic, strong) NSString *lastBody;
@property(nonatomic, strong) NSString *subject;
@property(nonatomic, strong) NSNumber *archived;
@property(nonatomic, strong) NSString *createdAt;
@property(nonatomic, strong) NSString *updatedAt;
@property(nonatomic, strong) NSDate *readAt;
@property(nonatomic, strong) PFProfile *profile;
@property(nonatomic, strong) NSArray *messages;
@property(nonatomic, strong) NSNumber *previousThreadId;
@property(nonatomic, strong) NSNumber *nextThreadId;

+ (NSString *)createEndPoint;

+ (NSString *)endPointWithThreadId;
- (NSString *)pathWithThreadId;

+ (NSString *)endPointForMessages;
- (NSString *)messagesWithThreadId;

+ (NSString *)endPointForUsers;
- (NSString *)usersWithThreadId;

+ (NSString *)endPointForReply;
- (NSString *)replyWithThreadId;

@end