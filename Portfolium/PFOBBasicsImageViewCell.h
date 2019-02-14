//
//  PFOBBasicsImageViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 7/31/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFTableViewCell.h"

@interface PFOBBasicsImageViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UIImageView *avatar;
@property(nonatomic, strong) UILabel *label;

- (void)setLabelText:(NSString *)text animated:(BOOL)animated;

@end
