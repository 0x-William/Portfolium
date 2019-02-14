//
//  PFDetailImageViewItem.h
//  Portfolium
//
//  Created by John Eisberg on 12/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFCollectionViewItem.h"

@interface PFDetailImageViewItem : UICollectionViewCell<PFCollectionViewItem>

@property(nonatomic, strong) UIView *palateView;
@property(nonatomic, strong) UIImageView *mediaView;

@end
