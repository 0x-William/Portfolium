//
//  PFSearchTypeVC.h
//  Portfolium
//
//  Created by John Eisberg on 8/19/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFPagedDatasourceDelegate.h"
#import "PFNetworkViewItemDelegate.h"
#import "_PFEntryFeedVC.h"

@class PFSearchResultsVC;

@interface PFSearchTypeVC : _PFEntryFeedVC<UICollectionViewDataSource,
                                           UICollectionViewDelegate,
                                           PFNetworkViewItemDelegate>

@property (nonatomic, strong) UIButton *entriesButton;
@property (nonatomic, strong) UIButton *connectionsButton;

+ (PFSearchTypeVC *)_entries:(PFSearchResultsVC *)delegate q:(NSString *)q;
+ (PFSearchTypeVC *)_people:(PFSearchResultsVC *)delegate q:(NSString *)q;

@end
