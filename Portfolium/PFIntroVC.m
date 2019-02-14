//
//  PFOnboardingVC.m
//  Portfolium
//
//  Created by John Eisberg on 7/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFIntroVC.h"
#import "PFPanGesture.h"
#import "PFImage.h"
#import "PFCategoriesVC.h"
#import "PFAppDelegate.h"
#import "PFColor.h"
#import "PFErrorView.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "UIViewController+PFExtensions.h"
#import "PFSize.h"
#import "PFGoogleAnalytics.h"
#import "PFColor.h"

static const CGFloat kStepWidth = 60.0f;

static const NSInteger kMaxTiles = 4;
static const NSString *kUserViewedIntro = @"kUserViewedIntro";

@interface PFIntroVC ()

@property(nonatomic, strong) NSArray *images;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, strong) PFPanGesture *pan;

@end

@implementation PFIntroVC

+ (PFIntroVC *)_new:(NSInteger)index; {
    
    PFIntroVC *vc = [[PFIntroVC alloc] initWithNibName:nil bundle:nil];
    [vc setIndex:index];
    
    return vc;
}

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

- (void)viewDidLoad; {

    [super viewDidLoad];
    
    [self setUpImageBackButtonClear];
    
    self.view.backgroundColor = [PFColor introBackgroundColor];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [imageView setImage:[[PFIntroVC tiles] objectAtIndex:[self index]]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [[self view] addSubview:imageView];

    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(([PFSize screenWidth] - kStepWidth) / 2,
                                                                                 [PFSize screenHeight] - 100, kStepWidth, 35)];
    
    pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    pageControl.numberOfPages = kMaxTiles + 1;
    pageControl.currentPage = [self index];
    [[self view] addSubview:pageControl];
    [pageControl addTarget:self action:@selector(didPageChanged:) forControlEvents:UIControlEventValueChanged];
    
    @weakify(self)
    
    [self setPan:[[PFPanGesture alloc] init:[self view]
                                      block:^(UIPanGestureRecognizer *recognizer) {
                                          @strongify(self)
                                          
                                          if([recognizer velocityInView:recognizer.view].x > 0) {
                                              [[self navigationController] popViewControllerAnimated:YES];
                                          
                                          } else {
                                              
                                              if([self index] < kMaxTiles - 1) {
                                                  
                                                  [self pushIntro];
                                                  
                                              } else {
                                                  
                                                  [self pushCategories];
                                              }
                                          }
                                      }]];
    
    if([self index] == kMaxTiles - 1) {
        [PFIntroVC markViewed];
    }
}

- (void)didPageChanged:(UIPageControl*)sender{

    if(sender.currentPage < [self index]) {
        
        [[self navigationController] popViewControllerAnimated:YES];
        
    } else {
        
        if([self index] < kMaxTiles - 1) {
            
            [self pushIntro];
            
        } else {
            
            [self pushCategories];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    pageControl.currentPage = self.index;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kIntroPage
                       withIdentifier:@([self index] + 1)];
}

- (void)viewDidDisappear:(BOOL)animated; {
 
    [super viewDidDisappear:animated];
    
    if([self index] == kMaxTiles - 1 && [self isPushingViewController]) {
        
        [[self navigationController] setNavigationBarHidden:NO
                                                   animated:YES];
    }
}

- (void)viewDidLayoutSubviews; {
    
    [super viewDidLayoutSubviews];
    
    [self setExtendedLayoutIncludesOpaqueBars:YES];
}

- (void)pushIntro; {
    
    [[self navigationController] pushViewController:[PFIntroVC _new:[self index] + 1]
                                           animated:YES];
}

- (void)pushCategories; {
    
    [[[PFAppDelegate shared] window] setBackgroundColor:[PFColor lightGrayColor]];
    
    [[self navigationController] pushViewController:[PFCategoriesVC _intro]
                                           animated:YES];
}

@end
