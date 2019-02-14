//
//  PFLoginViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 7/27/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@class FAKFontAwesome;

@interface PFLoginViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UILabel *iconLabel;
@property(nonatomic, strong) UITextField *textField;

- (void)setIcon:(FAKFontAwesome *)icon;
- (void)setTextFieldPlaceholder:(NSString *)placeholder;

@end
