//
//  PFTagsVC.m
//  Portfolium
//
//  Created by John Eisberg on 11/24/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFTagsVC.h"
#import "PFMagicNumbers.h"
#import "PFApi.h"
#import "PFContentView.h"
#import "PFColor.h"
#import "PFEntryViewItem.h"
#import "PFFooterBufferView.h"
#import "PFActivityIndicatorView.h"
#import "PFNavigationController.h"
#import "PFEntry.h"
#import "PFMedia.h"
#import "PFEntryViewProvider.h"
#import "UIImageView+PFImageLoader.h"
#import "PFProfileVC.h"
#import "UIViewController+PFExtensions.h"
#import "PFSize.h"
#import "PFShim.h"

@interface PFTagsVC ()

@property(nonatomic, strong) UIView *shim;
@property(nonatomic, assign) BOOL shimmed;

@end

@implementation PFTagsVC

@synthesize shimmed = _shimmed;

+ (PFTagsVC *)_new:(NSString *)tag; {
    
    PFTagsVC *vc = [[PFTagsVC alloc] initWithNibName:nil bundle:nil];
    [vc setTag:tag];
    
    PFPagedDataSource *dataSource = [PFPagedDataSource dataSourceWithPageSize:kDefaultPageSize
                                                                   dataLoader:^(NSInteger pageNumber,
                                                                                PFApiFeedSuccessBlock successBlock,
                                                                                PFApiErrorHandlerBlock failure) {
                                                                       
                                                                       [[PFApi shared] tagFeed:tag
                                                                                    pageNumber:pageNumber
                                                                                       success:^(NSArray *data) {
                                                                                           successBlock(data);
                                                                                       }
                                                                                       failure:^NSError *(NSError *error) {
                                                                                           return error;
                                                                                       }];
                                                                   }];
    [dataSource setDelegate:vc];
    [vc setDataSource:dataSource];
    
    return vc;
}

- (void)loadView; {
    
    [self setTitle:[NSString stringWithFormat:@"#%@", [self tag]]];
    [self setUpImageBackButton];
    
    PFContentView *view = [[PFContentView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[PFColor lighterGrayColor]];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumInteritemSpacing:0.0f];
    [layout setMinimumLineSpacing:0.0f];
    [layout setSectionInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:layout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView registerClass:[PFEntryViewItem class]
       forCellWithReuseIdentifier:[PFEntryViewItem preferredReuseIdentifier]];
    [collectionView registerClass:[PFFooterBufferView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
              withReuseIdentifier:[PFFooterBufferView preferredReuseIdentifier]];
    [collectionView setAllowsMultipleSelection:NO];
    [collectionView setBackgroundColor:[PFColor lighterGrayColor]];
    [view setContentView:collectionView];
    [self setCollectionView:collectionView];
    [self setScrollView:collectionView];
    
    [self setView:view];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setShim:[PFShim hiddenBlackOpaqueFor:self]];
    
    [[[self contentView] spinner] startAnimating];
    
    [[self dataSource] load];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[self dataSource] numberOfItems];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PFEntryViewItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:
                             [PFEntryViewItem preferredReuseIdentifier] forIndexPath:indexPath];
    
    [[PFEntryViewProvider shared] entryForItemAtIndexPathBlock]
    (item, indexPath, [self dataSource], self);

    return item;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [[PFEntryViewProvider shared] sizeForItemAtIndexPathBlock]
    (indexPath, [self dataSource]);
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
    
    [[self collectionView] insertItemsAtIndexPaths:indexPaths];
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
        didRefreshItems:(NSInteger)items; {
    
    [[self collectionView] reloadData];
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
 didTransitionFromState:(PFPagedDataSourceState)fromState
                toState:(PFPagedDataSourceState)toState; {
    
    if (toState == PFPagedDataSourceStateEmpty) {
    }
}

- (void)pushUserProfile:(NSNumber *)userId; {
    
    [[self rootNavigationController] pushViewController:[PFProfileVC _new:userId]
                                               animated:YES
                                                   shim:self];
}

- (void)showShim; {
    
    [[self shim] setHidden:NO];
}

- (void)hideShim; {
    
    [[self shim] setHidden:YES];
}

- (BOOL)shimmed; {
    
    return _shimmed;
}

- (void)setShimmed:(BOOL)shimmed; {
    
    _shimmed = shimmed;
}

- (PFNavigationController *)rootNavigationController; {
    
    return (PFNavigationController *)[self navigationController];
}

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

@end
