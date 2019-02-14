//
//  PFMessagesViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 8/10/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"
#import "SWTableViewCell.h"

@class TTTAttributedLabel;
@class PFThread;
@class PFMessagesVC;

@interface PFMessagesViewCell : SWTableViewCell<PFTableViewCell>

@property(nonatomic, strong) UIImageView *avatarView;
@property(nonatomic, strong) TTTAttributedLabel *usernameLabel;
@property(nonatomic, strong) UILabel *subjectLabel;
@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) NSNumber *threadId;
@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, weak) PFMessagesVC *vc;

+ (CGSize)preferredAvatarSize;

+ (CGFloat)heightForRowAtThread:(PFThread *)thread;

@end

