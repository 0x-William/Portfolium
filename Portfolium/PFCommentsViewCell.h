//
//  PFCommentsViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 8/9/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@class TTTAttributedLabel;
@class PFComment;
@class PFCommentsVC;

@interface PFCommentsViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UIImageView *avatarView;
@property(nonatomic, strong) TTTAttributedLabel *usernameLabel;
@property(nonatomic, strong) TTTAttributedLabel *dateLabel;
@property(nonatomic, strong) NSString *comment;
@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, weak) PFCommentsVC *delegate;

+ (CGSize)preferredAvatarSize;

+ (CGFloat)heightForRowAtComment:(PFComment *)comment;

@end
