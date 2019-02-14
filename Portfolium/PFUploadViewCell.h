//
//  PFUploadViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 1/7/15.
//  Copyright (c) 2015 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

@interface PFUploadViewCell : UITableViewCell<PFTableViewCell>

@property(nonatomic, strong) UIImageView *image;
@property(nonatomic, strong) UIProgressView *progressView;

@end
