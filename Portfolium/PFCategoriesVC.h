//
//  PFCategoriesVC.h
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFRootViewController.h"

@interface PFCategoriesVC : UIViewController<UICollectionViewDelegate,
                                             UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong) UIView *shim;
@property(nonatomic, readwrite) PFViewControllerState state;

+ (PFCategoriesVC *)_new;
+ (PFCategoriesVC *)_intro;

- (void)loadData;

@end
