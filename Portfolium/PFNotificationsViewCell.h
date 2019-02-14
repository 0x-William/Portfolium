//
//  PFNotificationsViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 8/18/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@class PFNotificationsVC;
@class PFNotification;

@interface PFNotificationsViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UIImageView *avatarView;
@property(nonatomic, strong) NSString *notification;
@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, weak) PFNotificationsVC *delegate;
@property(nonatomic, strong) UILabel *notificationLabel;

+ (CGSize)preferredAvatarSize;

+ (CGFloat)heightForRowAtNotification:(PFNotification *)notification;

@end
