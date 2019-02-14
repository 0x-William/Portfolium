//
//  PFEntryCategoryFeedVC.m
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFCategoryFeedVC.h"
#import "PFApi.h"
#import "PFSystemCategory.h"
#import "PFMagicNumbers.h"
#import "PFContentView.h"
#import "PFColor.h"
#import "PFEntryViewItem.h"
#import "PFActivityIndicatorView.h"
#import "PFEntryViewProvider.h"
#import "UIControl+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFImage.h"
#import "PFBarButtonContainer.h"
#import "PFHomeVC.h"
#import "UINavigationBar+PFExtensions.h"
#import "UIViewController+PFExtensions.h"
#import "CSStickyHeaderFlowLayout.h"
#import "PFEntryHeaderView.h"
#import "PFGradient.h"
#import "UIImageView+PFImageLoader.h"
#import "NSString+PFExtensions.h"
#import "PFLandingCategoryFeedVC.h"
#import "PFSize.h"
#import "PFDetailVC.h"
#import "PFGoogleAnalytics.h"
#import "UIColor+PFEntensions.h"
#import "PFFont.h"
#import "PFImage.h"
#import "FAKFontAwesome.h"
#import "PFFooterBufferView.h"
#import "NSAttributedString+CCLFormat.h"

const static CGFloat kPadding = 0.0f;
const static CGFloat kFadeAt = 250.0f;

static NSString *kHeaderReuseIdentifier = @"kHeaderReuseIdentifier";
static NSString *kSlugReuseIdentifier = @"kSlugReuseIdentifier";

@interface PFCategoryFeedVC ()

@property(nonatomic, strong) PFSystemCategory *category;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIView *rightBarButtonContainer;
@property(nonatomic, strong) UIView *shim;
@property(nonatomic, strong) UIButton *addForView;

@end

@implementation PFCategoryFeedVC

+ (PFCategoryFeedVC *)_category:(PFSystemCategory *)category; {
    
    PFCategoryFeedVC *vc = [[PFCategoryFeedVC alloc] initWithNibName:nil bundle:nil];
    [vc setCategory:category];
    
    PFPagedDataSource *dataSource = [PFPagedDataSource dataSourceWithPageSize:kDefaultPageSize
                                                                   dataLoader:^(NSInteger pageNumber,
                                                                                PFApiFeedSuccessBlock successBlock,
                                                                                PFApiErrorHandlerBlock failure) {
                                                                       
                                                                       [[PFApi shared] categoryFeedById:[category categoryId]
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

+ (PFLandingCategoryFeedVC *)_landing:(PFSystemCategory *)category; {
    
    PFLandingCategoryFeedVC *vc = [[PFLandingCategoryFeedVC alloc] initWithNibName:nil bundle:nil];
    [vc setCategory:category];
    
    PFPagedDataSource *dataSource = [PFPagedDataSource dataSourceWithPageSize:kDefaultPageSize
                                                                   dataLoader:^(NSInteger pageNumber,
                                                                                PFApiFeedSuccessBlock successBlock,
                                                                                PFApiErrorHandlerBlock failure) {
                                                                       
                                                                       [[PFApi shared] categoryFeedById:[category categoryId]
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
    [collectionView registerClass:[PFEntryViewItem class]
       forCellWithReuseIdentifier:[PFEntryViewItem preferredReuseIdentifier]];
    [collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
              withReuseIdentifier:kHeaderReuseIdentifier];
    [collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:kSlugReuseIdentifier];
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
    
    UIButton *addForView = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [addForView setBackgroundColor:[UIColor clearColor]];
    [addForView setAlpha:0.0f];
    [addForView setAdjustsImageWhenHighlighted:NO];
    [addForView setFrame:CGRectMake([PFSize screenWidth] - 66.0f , 25.0f, 60.0f, 36.0f)];
    
    FAKFontAwesome *cloudIcon = [FAKFontAwesome cloudUploadIconWithSize:14];
    [cloudIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    NSAttributedString *cloud = [cloudIcon attributedString];
    UIFont *font = [UIFont systemFontOfSize:14];
    NSAttributedString *add = [[NSAttributedString alloc] initWithString:@"Add" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSAttributedString *combined = [NSAttributedString attributedStringWithFormat:@"%@ %@", cloud, add];
    
    [addForView setAttributedTitle:combined
                          forState:UIControlStateNormal];
    
    [addForView setBackgroundImage:[PFImage like]
                          forState:UIControlStateNormal];
    [[addForView titleLabel] setFont:[PFFont systemFontOfMediumSize]];
    [[self view] addSubview:addForView];
    [self setAddForView:addForView];
    
    @weakify(self)
    
    [addForView bk_addEventHandler:^(id sender) {
        
        @strongify(self) [self plusButtonAction];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    PFEntryHeaderView *headerView = [[PFEntryHeaderView alloc]
                                     initWithFrame:CGRectMake(0, 0,
                                                              [PFEntryHeaderView preferredSize].width,
                                                              [PFEntryHeaderView preferredSize].height)];
    
    [[headerView nameLabel] setText:[[self category] name]];
    [[headerView descriptionLabel] setText:[[self category] desc]];
    
    [headerView setBackgroundColor:[UIColor colorWithHexString:[[self category] hex]]];
    [headerView setImageFor:[self category] animated:YES callback:^(id sender) {
        
        @strongify(self)
        
        [UIView animateWithDuration:0.2f animations:^{
            [[self addForView] setAlpha:1.0f];
        }];
    }];
    
    [self setHeaderView:headerView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(5, 29, 36, 26)];
    
    FAKFontAwesome *backIcon = [FAKFontAwesome chevronLeftIconWithSize:18];
    [backIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    [backButton setAttributedTitle:[backIcon attributedString] forState:UIControlStateNormal];
    [backButton bk_addEventHandler:^(id sender) {
        [[self navigationController] popViewControllerAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:backButton];
    [self setBackButton:backButton];
    
    UIView *rightBarButtonContainer = [PFBarButtonContainer add:^(id sender) {
        
        @strongify(self) [self plusButtonAction];
    }];
    
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc]
                                                  initWithCustomView:rightBarButtonContainer]];
    
    [self setRightBarButtonContainer:rightBarButtonContainer];
    
    PFActivityIndicatorView *spinner = [[self contentView] spinner];
    CGRect frame = spinner.frame;
    frame.origin.y = frame.origin.y + 204;
    spinner.frame = frame;
    
    CSStickyHeaderFlowLayout *layout = [self stickyHeaderFlowLayout];
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        
        [layout setParallaxHeaderReferenceSize:CGSizeMake([PFSize screenWidth],
                                                          [PFEntryHeaderView preferredSize].height)];
        [layout setParallaxHeaderMinimumReferenceSize:CGSizeMake([PFSize screenWidth],
                                                                 [PFEntryHeaderView preferredSize].height)];
        [layout setParallaxHeaderAlwaysOnTop:YES];
        [layout setDisableStickyHeaders:YES];
        [layout setHeaderReferenceSize:CGSizeMake(0, 0)];
    }
    
    [[[self contentView] spinner] startAnimating];
    [[self dataSource] load];
    
    [self setTitle:[[self category] name]];
    
    UIView *shim = [[UIView alloc] initWithFrame:
                    CGRectMake(0, 0, [PFSize screenWidth], [self applicationFrameOffset])];
    
    [shim setBackgroundColor:[UIColor blackColor]];
    [shim setAlpha:0.8];
    [shim setHidden:YES];
    [[self view] addSubview:shim];
    [self setShim:shim];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    [self setUpImageBackButton];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kCategoryEntriesPage
                       withIdentifier:[[self category] categoryId]];
    
    [self titleViewDidLoad];
    [self showTitleElements];
}

- (void)viewWillDisappear:(BOOL)animated; {
    
    [super viewWillDisappear:animated];
    
    [self hideTitleElements];
    
    [[self shim] setAlpha:[self currentNavigationBarAlpha]];
    [[self shim] setHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated; {
    
    [super viewDidDisappear:animated];
    
    [self hideTitleElements];
    
    [[self shim] setAlpha:[self currentNavigationBarAlpha]];
    [[self shim] setHidden:YES];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [[self collectionView] setContentInset:UIEdgeInsetsZero];
    [self setExtendedLayoutIncludesOpaqueBars:NO];
    
    [[self contentView] layoutSubviews];
}

#pragma mark - UICollectionViewDelegate

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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *view =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                           withReuseIdentifier:kSlugReuseIdentifier
                                                  forIndexPath:indexPath];
        return view;
        
    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        
        UICollectionReusableView *view =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                           withReuseIdentifier:kHeaderReuseIdentifier
                                                  forIndexPath:indexPath];
        [view addSubview:[self headerView]];
        
        return view;
    
    } else if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        PFFooterBufferView *buffer = [collectionView dequeueReusableSupplementaryViewOfKind:
                                      UICollectionElementKindSectionFooter withReuseIdentifier:
                                      [PFFooterBufferView preferredReuseIdentifier]
                                                                               forIndexPath:indexPath];
        
        [buffer setBackgroundColor:[PFColor lighterGrayColor]];
        
        return buffer;
    }
    
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
    
    [[self collectionView] insertItemsAtIndexPaths:indexPaths];
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
        didRefreshItems:(NSInteger)items; {
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
 didTransitionFromState:(PFPagedDataSourceState)fromState
                toState:(PFPagedDataSourceState)toState; {
    
    if (toState == PFPagedDataSourceStateEmpty) {
    }
}

- (void)titleViewDidLoad; {
    
    if([self contentOffsetY] > kFadeAt) {
        
        [self setCurrentNavigationBarAlpha:([self contentOffsetY] - kFadeAt)/50];
        [[[self navigationController] navigationBar] setAlpha:[self currentNavigationBarAlpha]];
        
    } else {
        
        [self setCurrentNavigationBarAlpha:0];
        [[[self navigationController] navigationBar] setAlpha:0.01];
    }
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
}

- (void)plusButtonAction; {
    
    [[PFHomeVC shared] plusButtonAction];
}

- (CSStickyHeaderFlowLayout *)stickyHeaderFlowLayout; {
    
    return (CSStickyHeaderFlowLayout *)[[self collectionView] collectionViewLayout];
}

- (void)hideTitleElements; {
    
    [self setTitle:[NSString empty]];
    
    [[self rightBarButtonContainer] setHidden:YES];
}

- (void)showTitleElements; {
    
    [self setTitle:[[self category] name]];
    
    [[self rightBarButtonContainer] setHidden:NO];
}

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

@end
