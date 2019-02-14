//
//  PFEntryCommentViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"
#import "PFEntryViewDelegate.h"
#import "PFProfile.h"

@class TTTAttributedLabel;

@interface PFEntryCommentViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UIImageView *avatarView;
@property(nonatomic, strong) NSString *fullname;
@property(nonatomic, strong) NSString *comment;
@property(nonatomic, strong) PFProfile *profile;

@property(nonatomic, weak) id<PFEntryViewDelegate> entryDelegate;

+ (CGSize)preferredAvatarSize;

@end
