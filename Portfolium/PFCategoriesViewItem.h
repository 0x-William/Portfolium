//
//  PFCategoriesViewItem.h
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFCollectionViewItem.h"

@interface PFCategoriesViewItem : UICollectionViewCell<PFCollectionViewItem>

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UIImageView *imageView;

- (void)pop:(void(^)(void))callback;

@end