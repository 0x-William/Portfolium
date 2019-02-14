//
//  PFAddEntryViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 11/16/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@interface PFAddEntryViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UITextField *textField;

- (void)setPlaceholderText:(NSString *)text animated:(BOOL)animated;

@end