//
//  PFThreadViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 8/12/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"
#import "SWTableViewCell.h"

@class TTTAttributedLabel;
@class PFThread;
@class PFThreadVC;
@class PFMessage;

@interface PFThreadViewCell : SWTableViewCell<PFTableViewCell>

@property(nonatomic, strong) UIImageView *avatarView;
@property(nonatomic, strong) TTTAttributedLabel *nameLabel;
@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, strong) NSNumber *threadId;
@property(nonatomic, weak) PFThreadVC *vc;

+ (CGSize)preferredAvatarSize;

+ (CGFloat)heightForRowAtThread:(PFMessage *)message;

@end