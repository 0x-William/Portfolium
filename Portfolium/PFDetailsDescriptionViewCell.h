//
//  PFDetailsDescriptionViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 8/10/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@interface PFDetailsDescriptionViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) NSString *caption;

+ (PFDetailsDescriptionViewCell *)build:(UITableView *)tableView;
+ (CGFloat)heightForRowAtCaption:(NSString *)caption;

@end
