//
//  PFOBCategoriesVC.h
//  Portfolium
//
//  Created by John Eisberg on 7/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFCategoriesVC.h"
#import "PFErrorHandler.h"

@interface PFOBCategoriesVC : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, readwrite) PFViewControllerState state;
@property(nonatomic, strong) UIView *rightBarButtonContainer;
@property(nonatomic, strong) NSString *headerString;
@property(nonatomic, strong) PFErrorHandlerBlock errorBlock;

+ (PFOBCategoriesVC *) _new;

- (void)loadViewWithContentOffset:(CGFloat)contentOffset;
- (void)loadData;

@end