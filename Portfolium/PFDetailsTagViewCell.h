//
//  PFDetailsTagViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 8/9/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@class TTTAttributedLabel;

@interface PFDetailsTagViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) TTTAttributedLabel *tagsLabel;
@property(nonatomic, strong) NSArray *tags;

+ (PFDetailsTagViewCell *)build:(UITableView *)tableView;

+ (CGFloat)heightForRowAtTags:(NSArray *)tags;

@end
