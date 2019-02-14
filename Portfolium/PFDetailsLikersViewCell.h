//
//  PFDetailsLikersViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 11/22/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@interface PFDetailsLikersViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) NSArray *likers;
@property(nonatomic, strong) NSMutableArray *likersImageViews;

+ (CGSize)preferredAvatarSize;

+ (PFDetailsLikersViewCell *)build:(UITableView *)tableView;

+ (CGFloat)getHeight;

@end
