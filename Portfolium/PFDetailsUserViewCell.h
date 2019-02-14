//
//  PFDetailsUserViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 8/9/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@class TTTAttributedLabel;
@class PFDetailVC;

@interface PFDetailsUserViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UIImageView *avatarView;
@property(nonatomic, strong) TTTAttributedLabel *usernameLabel;
@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, weak) PFDetailVC *delegate;
@property(nonatomic, strong) UIButton *statusButton;

+ (PFDetailsUserViewCell *)build:(UITableView *)tableView;

+ (CGSize)preferredAvatarSize;

+ (CGFloat)getHeight;

@end
