//
//  PFEntryLandingFeed.m
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFLandingCategoryFeedVC.h"
#import "PFContentView.h"
#import "PFApi.h"
#import "PFLandingProfileVC.h"
#import "PFLandingCommentsVC.h"
#import "PFColor.h"
#import "CSStickyHeaderFlowLayout.h"
#import "PFEntryLandingViewItem.h"
#import "PFEntryViewProvider.h"
#import "PFJoinVC.h"
#import "PFLandingVC.h"
#import "PFLandingDetailVC.h"
#import "UIImageView+PFImageLoader.h"
#import "PFEntryHeaderView.h"
#import "PFFooterBufferView.h"

const static CGFloat kPadding = 0.0f;
static NSString *kHeaderReuseIdentifier = @"kHeaderReuseIdentifier";
static NSString *kSlugReuseIdentifier = @"kSlugReuseIdentifier";

@interface PFLandingCategoryFeedVC ()

@end

@implementation PFLandingCategoryFeedVC

- (void)loadView; {
    
    PFContentView *view = [[PFContentView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[PFColor lighterGrayColor]];
    
    UICollectionViewFlowLayout *layout = [[CSStickyHeaderFlowLayout alloc] init];
    [layout setMinimumInteritemSpacing:kPadding];
    [layout setMinimumLineSpacing:kPadding];
    [layout setSectionInset:UIEdgeInsetsMake(kPadding,
                                             kPadding,
                                             kPadding,
                                             kPadding)];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:layout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView registerClass:[PFEntryLandingViewItem class]
       forCellWithReuseIdentifier:[PFEntryLandingViewItem preferredReuseIdentifier]];
    [collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
              withReuseIdentifier:kHeaderReuseIdentifier];
    [collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:kSlugReuseIdentifier];
    [collectionView setBackgroundColor:[PFColor lighterGrayColor]];
    [collectionView registerClass:[PFFooterBufferView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
              withReuseIdentifier:[PFFooterBufferView preferredReuseIdentifier]];
    [view setContentView:collectionView];
    [self setCollectionView:collectionView];
    [self setScrollView:collectionView];
    
    [self setView:view];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PFEntryLandingViewItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:
                             [PFEntryLandingViewItem preferredReuseIdentifier] forIndexPath:indexPath];
    
    [[PFEntryViewProvider shared] entryForItemAtIndexPathBlock]
    (item, indexPath, [self dataSource], self);
    
    return item;
}

- (void)plusButtonAction; {
    
    [[PFLandingVC shared] pushJoinVC];
}

- (void)pushUserProfile:(NSNumber *)userId; {
    
    [[self navigationController] pushViewController:[PFLandingProfileVC _new:userId]
                                           animated:YES];
}

- (void)pushComments:(NSNumber *)entryId; {
    
    [[self navigationController] pushViewController:[PFCommentsVC _landing:entryId]
                                           animated:YES];
}

- (void)pushEntryDetail:(NSNumber *)entryId index:(NSInteger)index; {
    
    PFLandingDetailVC *vc = [PFLandingDetailVC _new:entryId delegate:self];
    
    [[self navigationController] pushViewController:vc animated:YES];
}

@end
