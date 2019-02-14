//
//  PFSearchesViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 8/19/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@class TTTAttributedLabel;

@interface PFSearchesViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) TTTAttributedLabel *searchLabel;

@end
