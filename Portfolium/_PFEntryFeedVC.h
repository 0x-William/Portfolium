//
//  _PFEntryFeed.h
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFPagedDatasource.h"
#import "PFEntryViewDelegate.h"
#import "PFPagedDataSourceDelegate.h"
#import "TTTAttributedLabel.h"

@interface _PFEntryFeedVC : UIViewController<PFEntryViewDelegate,
                                             PFPagedDataSourceDelegate,
                                             TTTAttributedLabelDelegate>

@property(nonatomic, strong) PFPagedDataSource *dataSource;
@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, strong) UIButton *dismissButton;
@property(nonatomic, assign) CGFloat currentOffsetY;
@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, assign) CGFloat contentOffsetY;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)refreshAnimated:(BOOL)animated;

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;

@end