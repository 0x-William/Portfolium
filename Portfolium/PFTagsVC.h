//
//  PFTagsVC.h
//  Portfolium
//
//  Created by John Eisberg on 11/24/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "_PFEntryFeedVC.h"
#import <UIKit/UIKit.h>
#import "PFRootViewController.h"
#import "PFPagedDatasourceDelegate.h"
#import "PFShimmedViewController.h"

@interface PFTagsVC : _PFEntryFeedVC<PFPagedDataSourceDelegate,
                                     UICollectionViewDataSource,
                                     UICollectionViewDelegate,
                                     PFShimmedViewController>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSString *tag;

+ (PFTagsVC *)_new:(NSString *)tag;

@end
