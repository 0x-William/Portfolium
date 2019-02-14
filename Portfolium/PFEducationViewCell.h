//
//  PFAboutViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 12/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@class TTTAttributedLabel;

@interface PFEducationViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UIImageView *avatarView;
@property(nonatomic, strong) TTTAttributedLabel *headerLabel;
@property(nonatomic, strong) TTTAttributedLabel *gpaLabel;
@property(nonatomic, strong) TTTAttributedLabel *datesLabel;
@property(nonatomic, strong) TTTAttributedLabel *descriptionLabel;

@end
