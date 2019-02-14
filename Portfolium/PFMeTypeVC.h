//
//  PFMeTypeVC.h
//  Portfolium
//
//  Created by John Eisberg on 8/19/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFPagedDatasourceDelegate.h"
#import "PFEntryViewDelegate.h"
#import "PFNetworkViewItemDelegate.h"
#import "PFProfileFeedVC.h"
#import "PFRootViewController.h"

@class PFMeVC;
@class PFProfileHeaderView;
@class PFProfileSectionHeaderView;

@interface PFMeTypeVC : PFProfileFeedVC<UICollectionViewDataSource,
                                        UICollectionViewDelegate,
                                        PFNetworkViewItemDelegate>

@property(nonatomic, assign) CGFloat currentNavigationBarAlpha;

+ (PFMeTypeVC *)_entries:(PFMeVC *)delegate;

+ (PFMeTypeVC *)_about:(PFMeVC *)delegate;

+ (PFMeTypeVC *)_connections:(PFMeVC *)delegate;

@end
