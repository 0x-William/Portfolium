//
//  PFIntro2VC.m
//  Portfolium
//
//  Created by John Eisberg on 12/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFIntro2VC.h"
#import "PFCView.h"
#import "PFIntroImageFlowLayout.h"
#import "PFSize.h"
#import "PFImage.h"
#import "PFIntroImageViewItem.h"
#import "PFImageFlickView.h"
#import "PFPanGesture.h"
#import "PFAppDelegate.h"
#import "PFColor.h"
#import "PFCategoriesVC.h"
#import "PFGoogleAnalytics.h"

static const NSString *kUserViewedIntro = @"kUserViewedIntro";

@interface PFIntro2VC ()

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) PFImageFlickView *flick;
@property(nonatomic, strong) PFPanGesture *pan;

@end

@implementation PFIntro2VC

+ (NSArray *)tiles; {
    
    static NSArray *_tiles;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        _tiles = @[[PFImage intro1],
                   [PFImage intro2],
                   [PFImage intro3],
                   [PFImage intro4]];
    });
    
    return _tiles;
}

+ (void)markViewed; {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:(NSString *)kUserViewedIntro];
    
    [[PFGoogleAnalytics shared] viewedIntroScreens];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isViewed; {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:(NSString *)kUserViewedIntro];
}

+ (PFIntro2VC *)_new; {
    
    PFIntro2VC *vc = [[PFIntro2VC alloc] initWithNibName:nil bundle:nil];
    
    return vc;
}

- (void)loadView; {
    
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [view setUserInteractionEnabled:YES];
    
    PFIntroImageFlowLayout *layout = [[PFIntroImageFlowLayout alloc] init];
    [layout setMinimumInteritemSpacing:0.0f];
    [layout setMinimumLineSpacing:0.0f];
    [layout setSectionInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:
                                        CGRectMake(0, 0, [PFSize screenWidth], [PFSize screenHeight])
                                                          collectionViewLayout:layout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView setAllowsMultipleSelection:NO];
    [collectionView registerClass:[PFIntroImageViewItem class]
       forCellWithReuseIdentifier:[PFIntroImageViewItem preferredReuseIdentifier]];
    [collectionView setBackgroundColor:[UIColor grayColor]];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setShowsVerticalScrollIndicator:NO];
    [self setCollectionView:collectionView];
    [view addSubview:collectionView];
    
    [self setView:view];
}

- (void)viewDidLoad; {
    
    PFImageFlickView *flick = [PFImageFlickView _new:[[PFIntro2VC tiles] count] + 1];
    [flick setBackgroundColor:[UIColor clearColor]];
    
    CGRect frame = flick.frame;
    frame.origin.y = [PFSize screenHeight] - 82;
    flick.frame = frame;
    
    [[self view] addSubview:flick];
    [self setFlick:flick];
}

- (void)viewDidLayoutSubviews; {
    
    [super viewDidLayoutSubviews];
    
    [self setExtendedLayoutIncludesOpaqueBars:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[PFIntro2VC tiles] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PFIntroImageViewItem *cell = (PFIntroImageViewItem *)
    [collectionView dequeueReusableCellWithReuseIdentifier:[PFIntroImageViewItem preferredReuseIdentifier]
                                              forIndexPath:indexPath];
    
    [[cell imageView] setImage:[[PFIntro2VC tiles] objectAtIndex:[indexPath row]]];
    if ([PFSize screenHeight] == IPHONE_4_HEIGHT)
        [[cell imageView] setContentMode:UIViewContentModeBottom];
    
    if([indexPath row] == [[PFIntro2VC tiles] count] - 1) {
        
        [self setPan:[[PFPanGesture alloc] init:[self collectionView]
                                          block:^(UIPanGestureRecognizer *recognizer) {
                                              
                                              if([recognizer velocityInView:recognizer.view].x > 0) {
                                                  [self userDidPopLastItem];
                                              } else {
                                                  [self userDidPushLastItem];
                                              }
                                          }]];
    } else {
        
        [[self collectionView] removeGestureRecognizer:[[self pan] recognizer]];
    }
    
    return cell;
}

- (void)userDidPopLastItem; {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:([[PFIntro2VC tiles] count] - 2)
                                                 inSection:0];
    
    [[self collectionView]scrollToItemAtIndexPath:indexPath
                                 atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)userDidPushLastItem; {
    
    [PFIntro2VC markViewed];
    
    [[[PFAppDelegate shared] window] setBackgroundColor:[PFColor lightGrayColor]];
    
    [[self navigationController] pushViewController:[PFCategoriesVC _intro]
                                           animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake([PFSize screenWidth], [PFSize screenHeight] + 14.0f);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView; {
    
    if([self flick] != nil && scrollView.contentOffset.x > 0) {
        
        [[self flick] setSelectedAtIndex:(scrollView.contentOffset.x / [PFSize screenWidth])];
    }
}

@end
