//
//  PFEntryProfileFeedVC.m
//  Portfolium
//
//  Created by John Eisberg on 10/14/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFProfileFeedVC.h"
#import "PFContentView.h"
#import "PFColor.h"
#import "CSStickyHeaderFlowLayout.h"
#import "PFEntryViewItem.h"
#import "PFNetworkViewItem.h"
#import "PFProfileSectionHeaderView.h"
#import "PFActivityIndicatorView.h"
#import "PFProfileHeaderView.h"
#import "PFRootViewController.h"
#import "PFProfileVC.h"
#import "PFSize.h"
#import "PFFooterBufferView.h"
#import "PFProfileSectionSlugView.h"
#import "PFAboutViewItem.h"
#import "UIViewController+PFExtensions.h"

static NSString *kHeaderReuseIdentifier = @"PFProfileTypeVCHeader";
static NSString *kSectionHeaderReuseIdentifier = @"PFProfileTypeVCSectionHeader";
static NSString *kEmptyCellIdentifier = @"EmptyCell";

@interface PFProfileFeedVC ()

@property(nonatomic, assign) PFViewControllerState state;
@property(nonatomic, strong) PFProfileSectionSlugView *slug;

@end

@implementation PFProfileFeedVC
@synthesize pageState;

- (void)loadView; {
    
    PFContentView *view = [[PFContentView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[PFColor lighterGrayColor]];
    [view setContentOffset:0.0f];
    pageState = PFPagedDataSourceStateLoading;
    
    UICollectionViewFlowLayout *layout = [[CSStickyHeaderFlowLayout alloc] init];
    [layout setMinimumInteritemSpacing:2];
    [layout setMinimumLineSpacing:[self padding]];
    [layout setSectionInset:UIEdgeInsetsMake([self padding],
                                             [self padding],
                                             [self padding],
                                             [self padding])];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [PFSize screenWidth], 44)];
    [footerView setBackgroundColor:[UIColor whiteColor]];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:layout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView registerClass:[PFEntryViewItem class]
       forCellWithReuseIdentifier:[PFEntryViewItem preferredReuseIdentifier]];
    [collectionView registerClass:[PFAboutViewItem class]
       forCellWithReuseIdentifier:[PFAboutViewItem preferredReuseIdentifier]];
    [collectionView registerClass:[PFNetworkViewItem class]
       forCellWithReuseIdentifier:[PFNetworkViewItem preferredReuseIdentifier]];
    [collectionView registerClass:[UICollectionViewCell class]
       forCellWithReuseIdentifier:kEmptyCellIdentifier];
    [collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
              withReuseIdentifier:kHeaderReuseIdentifier];
    [collectionView registerClass:[PFProfileSectionHeaderView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:kSectionHeaderReuseIdentifier];
    [collectionView setBackgroundColor:[PFColor lighterGrayColor]];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView registerClass:[PFFooterBufferView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
              withReuseIdentifier:[PFFooterBufferView preferredReuseIdentifier]];

    [view setContentView:collectionView];
    [self setCollectionView:collectionView];
    [self setScrollView:collectionView];
    
    [self setView:view];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    PFActivityIndicatorView *spinner = [[self contentView] spinner];
    CGRect frame = spinner.frame;
    frame.origin.y = frame.origin.y + 240;
    spinner.frame = frame;
    
    CSStickyHeaderFlowLayout *layout = [self stickyHeaderFlowLayout];
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        
        [layout setParallaxHeaderReferenceSize:[PFProfileHeaderView preferredSize]];
        [layout setParallaxHeaderMinimumReferenceSize:[PFProfileHeaderView preferredSize]];
        [layout setParallaxHeaderAlwaysOnTop:YES];
        [layout setDisableStickyHeaders:NO];
        [layout setHeaderReferenceSize:CGSizeMake(0, [PFProfileSectionHeaderView preferredSize].height)];
    }
    
    PFProfileHeaderView *headerView = [[PFProfileHeaderView alloc]
                                       initWithFrame:CGRectMake(0, 0,
                                                                [PFProfileHeaderView preferredSize].width,
                                                                [PFProfileHeaderView preferredSize].height)];
    [self setHeaderView:headerView];
    
    PFProfileSectionSlugView *slug = [[PFProfileSectionSlugView alloc] initWithFrame:
                                      CGRectMake(0, [PFProfileHeaderView preferredSize].height,
                                                 [PFProfileHeaderView preferredSize].width,
                                                 [PFProfileSectionHeaderView preferredSize].height)];
    [slug setDelegate:[self delegate]];
    
    [[self view] addSubview:slug];
    [self setSlug:slug];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    [self titleViewDidLoad];
    
    if([self state] == PFViewControllerLaunching || [self state] == PFViewControllerEmpty) {
        
        [[[self contentView] spinner] startAnimating];
        [[self dataSource] load];
        
        [self setState:PFViewControllerReady];
    }
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [[self collectionView] setContentInset:UIEdgeInsetsZero];
    [self setExtendedLayoutIncludesOpaqueBars:NO];
    
    [[self contentView] layoutSubviews];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (pageState == PFPagedDataSourceStateEmpty) {
        return 1;
    }
    
    return [[self dataSource] numberOfItems];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section; {
    
    return [PFFooterBufferView size];
}

#pragma mark - ADPagedDataSourceDelegate

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
 didLoadAdditionalItems:(NSInteger)items; {
    
    [[[self contentView] spinner] stopAnimating];
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:items];
    NSInteger numberOfItems = [dataSource numberOfItems];
    
    for (int i = (int)numberOfItems - (int)items; i < numberOfItems; ++i) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [UIView setAnimationsEnabled:NO];
    
    [[self collectionView] performBatchUpdates:^{
        [[self collectionView] insertItemsAtIndexPaths:indexPaths];
    } completion:^(BOOL finished) {
        [UIView setAnimationsEnabled:YES];
    }];
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
        didRefreshItems:(NSInteger)items; {
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
 didTransitionFromState:(PFPagedDataSourceState)fromState
                toState:(PFPagedDataSourceState)toState; {
    
    pageState = toState;
    if (toState == PFPagedDataSourceStateEmpty) {
        [self.collectionView reloadData];
    }
}

- (void)pushUserProfile:(NSNumber *)userId; {
    
    [(id)[self delegate] pushUserProfile:userId];
}

- (void)pushComments:(NSNumber *)entryId; {
    
    [(id)[self delegate] pushComments:entryId];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView; {
    
    [self setContentOffsetY:[scrollView contentOffset].y];
    
    [self titleViewDidLoad];
    
    if([self contentOffsetY] > 0) {
        
        [[self headerView] headerViewDidScrollUp:[self contentOffsetY]];
        
    } else if([self contentOffsetY] < 0) {
        
        [[self headerView] headerViewDidScrollDown:[self contentOffsetY]];
        
    } else {
        
        [[self headerView] headerViewDidReturnToOrigin];
    }
    
    CGFloat targetOffset = [PFProfileHeaderView preferredSize].height - 64;
    
    if([self contentOffsetY] < targetOffset) {
     
        CGRect frame = [self slug].frame;
        frame.origin.y = [PFProfileHeaderView preferredSize].height - [self contentOffsetY];
        [self slug].frame = frame;
    
    } else {
        
        CGRect frame = [self slug].frame;
        frame.origin.y = 64;
        [self slug].frame = frame;
    }
}

- (void)titleViewDidLoad; {
    
    CGFloat targetOffset = [PFProfileHeaderView preferredSize].height - [self applicationFrameOffset];
    
    if([self contentOffsetY] > targetOffset) {
    
        [[[(id)[self delegate] navigationController] navigationBar] setAlpha:
         ([self contentOffsetY] - targetOffset)/50];
        
    } else {
        
        [[[(id)[self delegate] navigationController] navigationBar] setAlpha:0.01];
    }
}

- (void)networkViewItem:(PFNetworkViewItem *)item
          requestedPush:(NSNumber *)userId; {
    
    [self pushUserProfile:userId];
}

- (void)networkViewItem:(PFNetworkViewItem *)item requestedPushAtIndex:(NSInteger)index; {
    
    PFProfile *profile = [[[self dataSource] data] objectAtIndex:index];
    
    [[(id)[self delegate] navigationController] pushViewController:[PFProfileVC _new:[profile userId]]
                                                          animated:YES];
}

- (CSStickyHeaderFlowLayout *)stickyHeaderFlowLayout; {
    
    return (CSStickyHeaderFlowLayout *)[[self collectionView] collectionViewLayout];
}

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

@end
