//
//  PFDetailsSocialViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 8/9/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@class TTTAttributedLabel;

@interface PFDetailsSocialViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) TTTAttributedLabel *titleLabel;
@property(nonatomic, strong) UILabel *categoryLabel;
@property(nonatomic, strong) NSNumber *categoryId;
@property(nonatomic, strong) TTTAttributedLabel *starViewLabel;
@property(nonatomic, strong) TTTAttributedLabel *bubbleViewLabel;
@property(nonatomic, strong) TTTAttributedLabel *eyeViewLabel;

+ (PFDetailsSocialViewCell *)build:(UITableView *)tableView;
    
+ (CGFloat)getHeight:(NSString *)title;

@end
