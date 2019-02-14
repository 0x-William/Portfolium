//
//  PFOBCategoriesVC.m
//  Portfolium
//
//  Created by John Eisberg on 7/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFOBCategoriesVC.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFContentView.h"
#import "PFCategoriesViewItem.h"
#import "PFFont.h"
#import "PFColor.h"
#import "PFSystemCategory.h"
#import "PFBarButtonContainer.h"
#import "PFOnboarding.h"
#import "PFOBEducationVC.h"
#import "PFApi.h"
#import "PFAppDelegate.h"
#import "PFErrorHandler.h"
#import "PFDiscoverViewItem.h"
#import "PFGradient.h"
#import "PFImageLoader.h"
#import "UIImageView+PFImageLoader.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFActivityIndicatorView.h"
#import "PFSize.h"
#import "UIViewController+PFExtensions.h"
#import "PFGoogleAnalytics.h"
#import "PFOnboardingVC.h"

static CGFloat kImageMargin = 8.0f;

static NSString *kHeaderReuseIdentifier = @"kHeaderReuseIdentifier";
static NSInteger kMinCategories = 3;


@interface PFOBCategoriesVC ()

@property(nonatomic, assign) BOOL loadedHeader;

@end

@implementation PFOBCategoriesVC

+ (PFOBCategoriesVC *) _new; {
    
    PFOBCategoriesVC *vc = [[PFOBCategoriesVC alloc] initWithNibName:nil bundle:nil];
    [vc setHeaderString:NSLocalizedString(@"Select 3 or more categories you're interested in", nil)];
    
    @weakify(vc)
    
    [vc setErrorBlock:^NSError *(NSError *error) {
        
        @strongify(vc)
        
        [[PFErrorHandler shared] showInErrorBar:error
                                       delegate:nil
                                         inView:[vc view]
                                         header:PFHeaderOpaque];
        return error;
    }];

    
    return vc;
}

- (void)loadView; {
    
    [self loadViewWithContentOffset:30.0f];
}

- (void)loadViewWithContentOffset:(CGFloat)contentOffset; {
    
    PFContentView *view = [[PFContentView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[PFColor lighterGrayColor]];
    [view setContentOffset:contentOffset];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake([PFSize screenWidth] / 3.3, [PFSize screenWidth] / 3.3)];
    [layout setMinimumInteritemSpacing:(kImageMargin / 2)];
    [layout setMinimumLineSpacing:kImageMargin];
    [layout setSectionInset:UIEdgeInsetsMake(kImageMargin,
                                             kImageMargin,
                                             kImageMargin,
                                             kImageMargin)];
    
    [layout setHeaderReferenceSize:CGSizeMake(0, [self applicationFrameOffset])];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:layout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView registerClass:[PFCategoriesViewItem class]
       forCellWithReuseIdentifier:[PFCategoriesViewItem preferredReuseIdentifier]];
    [collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:kHeaderReuseIdentifier];
    [collectionView setAllowsMultipleSelection:YES];
    [collectionView setBackgroundColor:[PFColor lighterGrayColor]];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setShowsVerticalScrollIndicator:NO];
    [view setContentView:collectionView];
    [self setCollectionView:collectionView];
    
    [self setView:view];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [[self navigationItem] setTitleView:nil];
    [self setTitle:NSLocalizedString(@"Getting Started", nil)];
    [[self view] setBackgroundColor:[PFColor lighterGrayColor]];
    
    [[[self navigationController] navigationBar] restyleNavigationBarTranslucentBlack];
    
    @weakify(self)
    
    UIView *rightBarButtonContainer = [PFBarButtonContainer _continue:^(id sender) {
        
        @strongify(self)
        
        if([[[PFOnboarding shared] categories] count] >= kMinCategories) {
            
            [self prepareForApi];
            
            [[PFApi shared] postUserInterests:[[PFOnboarding shared] categories]
                                      success:^{
                                          
                                          [[self navigationController] pushViewController:[PFOBEducationVC _new]
                                                                                 animated:YES];
                                          
                                      } failure:^NSError *(NSError *error) {
                                          
                                          [self returnFromApi];
                                          
                                          return [self errorBlock](error);
                                      }];
        }
    }];
    
    [self setRightBarButtonContainer:rightBarButtonContainer];
    [[self rightBarButtonContainer] setAlpha:0.0f];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc]
                                                  initWithCustomView:[self rightBarButtonContainer]]];
    [[self continueButton] setAlpha:0.0f];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kOnboardingInterestsPage];
}

- (void)loadData; {
    
    [[[self contentView] spinner] startAnimating];
    
    @weakify(self)
    
    [[PFApi shared] systemCategories:^(NSArray *data) {
        
        @strongify(self)
        
        [self setDataSource:(id)data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[self collectionView] reloadData];
            [[[self contentView] spinner] stopAnimating];
            [self setState:PFViewControllerReady];
            
            if([data count] == 0) {
                [self setState:PFViewControllerEmpty];
            }
        });
        
    } failure:^NSError *(NSError *error) {
        
        @strongify(self)
        
        [[[self contentView] spinner] stopAnimating];
        
        return [self errorBlock](error);
    }];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    [[PFOnboardingVC shared] buildTabbarButton:0];
    
    [[[PFAppDelegate shared] window] setBackgroundColor:[PFColor lighterGrayColor]];
    
    [[self navigationController] setDelegate:(id)[[PFOnboardingVC shared]
                                                  navigationControllerDelegate]];
    
    if([self state] == PFViewControllerLaunching ||
       [self state] == PFViewControllerEmpty ||
       [[self dataSource] count] == 0) {
        
        [self loadData];
        [self setState:PFViewControllerReady];
    }
    
    [self categoriesWereUpdated];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *reusableview =
        [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                           withReuseIdentifier:kHeaderReuseIdentifier
                                                  forIndexPath:indexPath];
        if (reusableview == nil) {
            
            reusableview = [[UICollectionReusableView alloc] initWithFrame:
                            CGRectMake(0, 0, [PFSize screenWidth], [self applicationFrameOffset])];
        }
        
        if(![self loadedHeader]) {
        
            UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:
                                          CGRectMake(([PFSize screenWidth] - 200) / 2, 14, 200, 40)];
            
            [instructionsLabel setAlpha:0.0f];
            [instructionsLabel setFont:[PFFont fontOfMediumSize]];
            [instructionsLabel setTextColor:[PFColor darkerGrayColor]];
            [instructionsLabel setNumberOfLines:2];
            [instructionsLabel setTextAlignment:NSTextAlignmentCenter];
            [instructionsLabel setText:[self headerString]];
            [reusableview addSubview:instructionsLabel];
            
            [UIView animateWithDuration:1.0f animations:^{
                [instructionsLabel setAlpha:1.0];
            }];
            
            [self setLoadedHeader:YES];
        }
        
        return reusableview;
    }
    
    return reusableview;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section; {
    
    return [[self dataSource] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PFDiscoverViewItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:
                                [PFDiscoverViewItem preferredReuseIdentifier] forIndexPath:indexPath];
    
    PFSystemCategory *systemCategoryItem = [[self dataSource] objectAtIndex:[indexPath row]];
    
    [[item label] setText:[systemCategoryItem name]];
    
    [[item imageView] setImageWithUrl:[[systemCategoryItem gradient] url]
                  postProcessingBlock:[PFImageLoader centerAndCropToCircle:
                                       CGSizeMake(roundf([PFSize screenWidth] / 3), roundf([PFSize screenWidth] / 3))
                                                                    radius:6.0f]
                        progressBlock:nil
                     placeholderImage:nil
                               fadeIn:YES];
    
    if([[systemCategoryItem interested] integerValue] > 0) {
        
        [[[PFOnboarding shared] categories] addObject:[systemCategoryItem categoryId]];
        
        [self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
        [collectionView selectItemAtIndexPath:indexPath
                                     animated:NO
                               scrollPosition:UICollectionViewScrollPositionNone];
        
        [item setSelected:YES];
    }
    
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFCategoriesViewItem *item = (PFCategoriesViewItem *)
    [collectionView cellForItemAtIndexPath:indexPath];
    
    [item pop:^{
        
        [item setSelected:YES];
        [collectionView selectItemAtIndexPath:indexPath
                                     animated:NO
                               scrollPosition:UICollectionViewScrollPositionNone];
    }];
    
    PFSystemCategory *category = [[self dataSource] objectAtIndex:[indexPath row]];
    [[[PFOnboarding shared] categories] addObject:[category categoryId]];
    
    [self categoriesWereUpdated];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PFCategoriesViewItem *item = (PFCategoriesViewItem *)
    [collectionView cellForItemAtIndexPath:indexPath];
    
    [item pop:^{
        
        [item setSelected:NO];
        [collectionView deselectItemAtIndexPath:indexPath
                                       animated:NO];
        
        PFSystemCategory *category = [[self dataSource] objectAtIndex:[indexPath row]];
        [[[PFOnboarding shared] categories] removeObject:[category categoryId]];
        
        [self categoriesWereUpdated];
    }];
}

- (void)categoriesWereUpdated; {
    
    CGFloat alpha = 0.0f;
    
    if([[[PFOnboarding shared] categories] count] >= kMinCategories) {
        
        alpha = 1.0f;
        
        [[self rightBarButtonContainer] setUserInteractionEnabled:YES];
        [[self continueButton] setUserInteractionEnabled:YES];
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        
        [[self rightBarButtonContainer] setAlpha:alpha];
        [[self continueButton] setAlpha:alpha];
    }];
}

- (void)prepareForApi; {
    
    [[self continueButton] setUserInteractionEnabled:NO];
}

- (void)returnFromApi; {
    
    [[self continueButton] setUserInteractionEnabled:YES];
}

- (UIButton *)continueButton; {
    
    return [[[self rightBarButtonContainer] subviews] objectAtIndex:0];
}

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

@end
