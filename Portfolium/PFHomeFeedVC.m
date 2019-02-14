//
//  PFEntryHomeFeedVC.m
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFHomeFeedVC.h"
#import "PFMagicNumbers.h"
#import "PFApi.h"
#import "UIControl+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFImage.h"
#import "PFHomeVC.h"
#import "UIViewController+PFExtensions.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFContentView.h"
#import "PFColor.h"
#import "PFEntryViewItem.h"
#import "PFEntryViewProvider.h"
#import "PFActivityIndicatorView.h"
#import "PFProfileVC.h"
#import "PFErrorHandler.h"
#import "PFNavigationController.h"
#import "UIImageView+PFImageLoader.h"
#import "PFFooterBufferView.h"
#import "PFDetailVC.h"
#import "PFShim.h"
#import "PFTutorialView.h"
#import "PFAuthenticationProvider.h"
#import "PFGoogleAnalytics.h"
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
#import "FAKFontAwesome.h"
#import "PFAppDelegate.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PFMessagesVC.h"
#import "PFNotificationsVC.h"
#import "PFJeweledButton.h"

@interface PFHomeFeedVC ()

@property(nonatomic, readwrite) PFViewControllerState state;
@property(nonatomic, strong) UIView *shim;
@property(nonatomic, assign) BOOL shimmed;
@property(nonatomic, strong) PFTutorialView *tutorialView;
@property(nonatomic, strong) PFJeweledButton *bellButton;
@property(nonatomic, strong) PFJeweledButton *mailButton;

@end

@implementation PFHomeFeedVC

@synthesize shimmed = _shimmed;

+ (PFHomeFeedVC *)_new; {
    
    PFHomeFeedVC *vc = [[PFHomeFeedVC alloc] initWithNibName:nil bundle:nil];
    
    PFPagedDataSource *dataSource = [PFPagedDataSource dataSourceWithPageSize:kDefaultPageSize
                                                                   dataLoader:^(NSInteger pageNumber,
                                                                                PFApiFeedSuccessBlock successBlock,
                                                                                PFApiErrorHandlerBlock failure) {
                                                                       
                                                                       [[PFApi shared] homeFeed:pageNumber
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
    
    UIButton *gridButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [gridButton setFrame:CGRectMake(0, 0, 30, 30)];
    [gridButton setBackgroundColor:[UIColor clearColor]];
    
    FAKFontAwesome *gridIcon = [FAKFontAwesome thLargeIconWithSize:18];
    [gridIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    [gridButton setAttributedTitle:[gridIcon attributedString] forState:UIControlStateNormal];
    [gridButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
    
    [gridButton bk_addEventHandler:^(id sender) {
        
        [[PFHomeVC shared] gridButtonAction:sender];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *gridItem = [[UIBarButtonItem alloc] initWithCustomView:gridButton];
    [[self navigationItem] setLeftBarButtonItem:gridItem];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[PFImage logo]];
    [titleImage setBackgroundColor:[UIColor clearColor]];
    [[self navigationItem] setTitleView:titleImage];
    
    PFJeweledButton *mailButton = [PFJeweledButton _mail:^(id sender) {
        [self mailButtonAction:sender];
    }];
    
    UIBarButtonItem *mailItem = [[UIBarButtonItem alloc] initWithCustomView:mailButton];
    [self setMailButton:mailButton];
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc]
                                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                target:nil action:nil];
    [fixedSpaceBarButtonItem setWidth:0];
    
    PFJeweledButton *bellButton = [PFJeweledButton _bell:^(id sender) {
        [self bellButtonAction:sender];
    }];
    
    UIBarButtonItem *bellItem = [[UIBarButtonItem alloc] initWithCustomView:bellButton];
    [self setBellButton:bellButton];
    
    self.navigationItem.rightBarButtonItems = @[bellItem, fixedSpaceBarButtonItem,  mailItem];
    
    [self setShim:[PFShim blackOpaqueFor:self]];
    
    [self setTutorialView:[PFTutorialView tutorial]];
    
    @weakify(self)
    
    [RACObserve([PFAppDelegate shared], notifications) subscribeNext:^(NSNumber *notifications) {
        
        @strongify(self)
        
        [[self bellButton] setCount:notifications];
    }];
    
    [RACObserve([PFAppDelegate shared], messages) subscribeNext:^(NSNumber *messages) {
        
        @strongify(self)
        
        [[self mailButton] setCount:messages];
    }];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    if([self state] == PFViewControllerLaunching ||
       [self state] == PFViewControllerEmpty ||
       [[[self dataSource] data] count] == 0) {
        
        [self setState:PFViewControllerLoading];
        [[[self contentView] spinner] startAnimating];
        [[self dataSource] load];
    }
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kHomePage];
}

- (void)viewWillDisappear:(BOOL)animated; {
    
    [super viewWillDisappear:animated];
    
    [[self collectionView] stopRefreshAnimation];
}

- (void)viewDidLayoutSubviews; {
    
    [super viewDidLayoutSubviews];
    
    [[self collectionView] setContentInset:
     UIEdgeInsetsMake([self applicationFrameOffset], 0, 0, 0)];
    
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    [self.collectionView.pullToRefreshView setSize:CGSizeMake(40, 40)];
    [self.collectionView.pullToRefreshView setBorderColor:[PFColor blueColor]];
    [self.collectionView.pullToRefreshView setImageIcon:[PFImage pullDownIcon]];
    
    @weakify(self)
    
    [[self collectionView] addPullToRefreshActionHandler:^{
        
        @strongify(self) [[self dataSource] refresh];
    }];
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
    
    if(![[PFAuthenticationProvider shared] tutorialized]) {
        [[self tutorialView] launch];
    }
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
        didRefreshItems:(NSInteger)items; {
    
    [[self collectionView] reloadData];
    [[self collectionView] stopRefreshAnimation];
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
 didTransitionFromState:(PFPagedDataSourceState)fromState
                toState:(PFPagedDataSourceState)toState; {
    
    if (toState == PFPagedDataSourceStateEmpty) {
    }
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

- (void)pushUserProfile:(NSNumber *)userId; {
    
    [[self rootNavigationController] pushViewController:[PFProfileVC _new:userId]
                                               animated:YES
                                                   shim:self];
}

- (void)pushEntryDetail:(NSNumber *)entryId index:(NSInteger)index; {
    
    PFEntry *entry = [[[self dataSource] data] objectAtIndex:index];
    
    [[self rootNavigationController] pushViewController:[PFDetailVC _new:[entry entryId] delegate:self]
                                               animated:YES];
}

- (PFNavigationController *)rootNavigationController; {
    
    return (PFNavigationController *)[self navigationController];
}

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

@end
