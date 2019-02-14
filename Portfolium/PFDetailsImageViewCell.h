//
//  PFDetailsImageViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 8/9/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@interface PFDetailsImageViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UIImageView *sliderImageView;

+ (PFDetailsImageViewCell *)build:(UITableView *)tableView;
+ (CGFloat)getHeight;

@end
