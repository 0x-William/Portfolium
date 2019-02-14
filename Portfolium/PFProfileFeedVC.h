//
//  PFEntryProfileFeedVC.h
//  Portfolium
//
//  Created by John Eisberg on 10/14/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "_PFEntryFeedVC.h"
#import "PFRootViewController.h"
#import "PFProfileSectionHeaderDelegate.h"

@class PFProfileHeaderView;
@class PFProfileSectionHeaderView;

@interface PFProfileFeedVC : _PFEntryFeedVC<UICollectionViewDataSource,
                                                 UICollectionViewDelegate>
@property(nonatomic, assign) CGFloat padding;
@property(nonatomic, weak) id<PFProfileSectionHeaderDelegate> delegate;
@property(nonatomic, strong) PFProfileHeaderView *headerView;
@property(nonatomic, strong) PFProfileSectionHeaderView *sectionHeader;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) PFPagedDataSourceState pageState;

- (void)titleViewDidLoad;

@end
