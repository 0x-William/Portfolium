//
//  PFErrorViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 9/5/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@interface PFErrorViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) NSString *error;

+ (CGFloat)heightForRowAtError:(NSString *)error;

@end
