//
//  PFOBEducationTextFieldCell.h
//  Portfolium
//
//  Created by John Eisberg on 7/31/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFTableViewCell.h"

@interface PFOBEducationTextFieldCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UITextField *textField;

- (void)setTextFieldText:(NSString *)text animated:(BOOL)animated;

@end