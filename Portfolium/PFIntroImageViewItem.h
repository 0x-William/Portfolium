//
//  PFIntroViewItem.h
//  Portfolium
//
//  Created by John Eisberg on 12/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFCollectionViewItem.h"

@interface PFIntroImageViewItem : UICollectionViewCell<PFCollectionViewItem>

@property(nonatomic, strong) UIImageView *imageView;

@end
