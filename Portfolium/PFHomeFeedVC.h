//
//  PFEntryHomeFeedVC.h
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFRootViewController.h"
#import "PFPagedDatasourceDelegate.h"
#import "_PFEntryFeedVC.h"
#import "PFShimmedViewController.h"

@interface PFHomeFeedVC : _PFEntryFeedVC<PFRootViewController,
                                              PFPagedDataSourceDelegate,
                                              UICollectionViewDataSource,
                                              UICollectionViewDelegate,
                                              PFShimmedViewController>

@property(nonatomic, strong) UICollectionView *collectionView;

+ (PFHomeFeedVC *)_new;

@end