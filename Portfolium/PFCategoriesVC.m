//
//  PFCategoriesVC.m
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFCategoriesVC.h"
#import "PFContentView.h"
#import "PFApi.h"
#import "PFSystemCategory.h"
#import "UIImageView+PFImageLoader.h"
#import "PFImg.h"
#import "PFActivityIndicatorView.h"
#import "PFDiscoverViewItem.h"
#import "PFColor.h"
#import "PFFont.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFLandingVC.h"
#import "PFGradient.h"
#import "PFErrorHandler.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFOnboardingVC.h"
#import "PFRootViewController.h"
#import "PFCategoryFeedVC.h"
#import "UIViewController+PFExtensions.h"
#import "PFSize.h"
#import "PFShim.h"
#import "PFGoogleAnalytics.h"

typedef void (^PFViewDidLoadBlock)();
typedef void (^PFViewWillAppearBlock)();

static const CGFloat kLayoutInset = 8.0f;

static NSString *kIntroCategoryPage = @"Intro Category Page";
static NSString *kTabbedCategoryPage = @"Tabbed Category Page";

@interface PFCategoriesVC ()

@property(nonatomic, strong) PFViewDidLoadBlock viewDidLoadBlock;
@property(nonatomic, strong) PFViewWillAppearBlock viewWillAppearBlock;

@end

@implementation PFCategoriesVC

+ (PFCategoriesVC *)_new; {
    
    PFCategoriesVC *vc = [[PFCategoriesVC alloc] initWithNibName:nil bundle:nil];
    
    @weakify(vc)
    
    [vc setViewDidLoadBlock:^{
        
        @strongify(vc)
        
        [vc defaultViewDidLoad];
    }];
    
    [vc setViewWillAppearBlock:^{
        
        @strongify(vc)
        
        [vc defaultViewWillAppear];
    }];
    
    return vc;
}

+ (PFCategoriesVC *)_intro; {
    
    PFCategoriesVC *vc = [[PFCategoriesVC alloc] initWithNibName:nil bundle:nil];
    
    @weakify(vc)
    
    [vc setViewDidLoadBlock:^{
        
        @strongify(vc)
        
        [vc defaultViewDidLoad];
        [[vc shim] setHidden:NO];
        
        [[vc navigationItem] setHidesBackButton:YES];
        [[vc navigationController] setDelegate:(id)[[PFLandingVC shared] strongDelegate]];
    }];
    
    [vc setViewWillAppearBlock:^{
        
        @strongify(vc)
        
        [[[vc navigationController] navigationBar] restyleNavigationBarTranslucentBlack];
        
        if([vc state] != PFViewControllerLaunching) {
            
            [[vc shim] setHidden:NO];
        
        } else {
            
            [vc setState:PFViewControllerReady];
        }
    }];
    
    return vc;
}

- (void)defaultViewDidLoad; {
    
    [self setShim:[PFShim blackOpaqueFor:self]];
}

- (void)defaultViewWillAppear; {
    
    [[[self navigationController] navigationBar] restyleNavigationBarTranslucentBlack];
    
    [[self shim] setHidden:NO];
}

- (void)loadView; {
    
    PFContentView *view = [[PFContentView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[PFColor lighterGrayColor]];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake([PFSize screenWidth] / 3.3, [PFSize screenWidth] / 3.3)];
    [layout setMinimumInteritemSpacing:(kLayoutInset / 2)];
    [layout setMinimumLineSpacing:kLayoutInset];
    [layout setSectionInset:UIEdgeInsetsMake(kLayoutInset,
                                             kLayoutInset,
                                             kLayoutInset,
                                             kLayoutInset)];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:layout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView registerClass:[PFDiscoverViewItem class]
       forCellWithReuseIdentifier:[PFDiscoverViewItem preferredReuseIdentifier]];
    [collectionView setBackgroundColor:[PFColor lighterGrayColor]];
    [collectionView setScrollsToTop:YES];
    [view setContentView:collectionView];
    [self setCollectionView:collectionView];
    
    [self setView:view];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [titleLabel setFont:[PFFont systemFontOfLargeSize]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:NSLocalizedString(@"Discover Amazing Work", nil)];
    [[self navigationItem] setTitleView:titleLabel];
    
    if([self viewDidLoadBlock]) {
        
        [self viewDidLoadBlock]();
    
    } else {
        
        [self defaultViewDidLoad];
    }
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
        
        [[PFErrorHandler shared] showInErrorBar:error
                                       delegate:nil
                                         inView:[self view]
                                         header:PFHeaderOpaque];
        return error;
    }];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    if([self state] == PFViewControllerLaunching ||
       [self state] == PFViewControllerEmpty ||
       [[self dataSource] count] == 0) {
        
        [self loadData];
        [self setState:PFViewControllerReady];
    }
    
    if([self viewWillAppearBlock]) {
        
        [self viewWillAppearBlock]();
    
    } else {
        
        [self defaultViewWillAppear];
    }
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kCategoriesPage];
    
    [[[self navigationController] navigationBar] setAlpha:1.0f];
    
    [[self shim] setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated; {
    
    [super viewWillDisappear:animated];
    
    [[self shim] setHidden:NO];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section; {
    
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
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFSystemCategory *category = [[self dataSource] objectAtIndex:[indexPath row]];
    
    [[self navigationController] pushViewController:(id)[PFCategoryFeedVC _landing:category]
                                           animated:YES];
}

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

@end
