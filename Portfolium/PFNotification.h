//
//  PFNotification.h
//  Portfolium
//
//  Created by John Eisberg on 8/18/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"
#import "PFUzer.h"
#import "PFEntry.h"

typedef enum {
    
    PFNotificationTypeJoin = 1,
    PFNotificationTypeLike,
    PFNotificationTypeComment,
    PFNotificationTypeCollaborator,
    PFNotificationTypeCommentBack,
    PFNotificationTypeConnectionRequest,
    PFNotificationTypeConnectionAccept,
    PFNotificationTypeFacebook,
    PFNotificationTypeReferral,
    PFNotificationTypeView = 16
    
}   PFNotificationType;

@interface PFNotification : NSObject<PFModel>

@property(nonatomic, strong) NSNumber *notificationId;
@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, strong) NSString *notification;
@property(nonatomic, strong) NSNumber *type;
@property(nonatomic, strong) NSString *label;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, strong) NSNumber *seen;
@property(nonatomic, strong) NSString *createdAt;
@property(nonatomic, strong) NSString *updatedAt;
@property(nonatomic, strong) PFUzer *user;
@property(nonatomic, strong) PFEntry *entry;

+ (NSString *)endPointSeen;

- (NSString *)endPointSeenPath;

@end