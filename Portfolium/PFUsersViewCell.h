//
//  PFUsersViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 8/12/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"
#import "PFUsersVC.h"

@interface PFUsersViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UIImageView *avatarView;
@property(nonatomic, strong) UILabel *usernameLabel;
@property(nonatomic, strong) UILabel *schoolLabel;
@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, weak) PFUsersVC *delegate;

+ (CGSize)preferredAvatarSize;

@end
