//
//  PFSettingsSwitchViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 8/27/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@interface PFSettingsSwitchViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UISwitch *swtch;

- (void)setLabelText:(NSString *)text animated:(BOOL)animated;

@end
