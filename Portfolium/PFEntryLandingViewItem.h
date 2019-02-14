//
//  PFEntryLandingItem.h
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFCollectionViewItem.h"
#import "PFEntryContainer.h"

@class PFEntryLandingView;

@interface PFEntryLandingViewItem : UICollectionViewCell<PFCollectionViewItem, PFEntryContainer>

@property(nonatomic, strong) PFEntryLandingView *entryView;

@end
