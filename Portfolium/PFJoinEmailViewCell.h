//
//  PFJoinEmailViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@interface PFJoinEmailViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UILabel *label;

- (void)setLabelText:(NSString *)text animated:(BOOL)animated;

@end
