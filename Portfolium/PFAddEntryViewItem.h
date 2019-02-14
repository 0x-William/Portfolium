//
//  PFAddEntryItemView.h
//  Portfolium
//
//  Created by John Eisberg on 12/4/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFCollectionViewItem.h"

@class PFAddEntryVC;

@interface PFAddEntryViewItem : UICollectionViewCell<PFCollectionViewItem>

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIButton *tapButton;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, weak) PFAddEntryVC *delegate;

- (void)pop:(void(^)(void))callback;

@end
