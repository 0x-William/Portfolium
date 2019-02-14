//
//  PFDiscoverViewItem.h
//  Portfolium
//
//  Created by John Eisberg on 8/7/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFCollectionViewItem.h"

@interface PFDiscoverViewItem : UICollectionViewCell<PFCollectionViewItem>

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UIImageView *imageView;

@end
