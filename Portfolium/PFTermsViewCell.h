//
//  PFTermsViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 10/4/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@interface PFTermsViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) NSString *terms;
@property(nonatomic, strong) NSString *header;

+ (CGFloat)heightForTermsLabel:(NSString *)text;

@end
