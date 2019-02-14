//
//  PFMessageNewViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 8/11/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@interface PFMessagesNewViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UITextField *textField;

- (void)setText:(NSString *)text animated:(BOOL)animated;
- (void)setTextFieldPlaceholder:(NSString *)placeholder;

@end
