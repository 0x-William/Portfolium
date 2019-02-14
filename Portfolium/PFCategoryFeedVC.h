//
//  PFEntryCategoryFeedVC.h
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "_PFEntryFeedVC.h"

@class PFSystemCategory;
@class PFEntryLandingFeedVC;
@class PFEntryHeaderView;

@interface PFCategoryFeedVC : _PFEntryFeedVC<UICollectionViewDataSource,
                                             UICollectionViewDelegate>

+ (PFCategoryFeedVC *)_category:(PFSystemCategory *)category;
+ (PFEntryLandingFeedVC *)_landing:(PFSystemCategory *)category;

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) PFEntryHeaderView *headerView;
@property(nonatomic, assign) CGFloat currentNavigationBarAlpha;

@end
