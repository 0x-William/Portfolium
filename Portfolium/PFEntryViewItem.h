//
//  PFEntryViewItem.h
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFCollectionViewItem.h"
#import "PFEntryContainer.h"

@class PFEntryView;

@interface PFEntryViewItem : UICollectionViewCell<PFCollectionViewItem, PFEntryContainer>

@property(nonatomic, strong) PFEntryView *entryView;

@end
