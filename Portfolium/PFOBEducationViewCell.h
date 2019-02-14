//
//  PFOBEducationViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 7/30/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@interface PFOBEducationViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UILabel *label;

- (void)setLabelText:(NSString *)text animated:(BOOL)animated;

@end
