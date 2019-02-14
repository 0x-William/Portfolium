//
//  PFRootNavigationControllerDelegate.m
//  Portfolium
//
//  Created by John Eisberg on 8/7/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFNavigationControllerDelegate.h"
#import "PFHomeFeedVC.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFShimmedViewController.h"
#import "PFDiscoverVC.h"
#import "PFProfileVC.h"
#import "PFCategoryFeedVC.h"
#import "PFMeVC.h"
#import "PFNetworkVC.h"
#import "PFMessagesVC.h"
#import "PFShimmedViewController.h"
#import "PFThreadVC.h"
#import "PFUsersVC.h"
#import "PFNotificationsVC.h"
#import "PFSearchResultsVC.h"
#import "PFEditProfileVC.h"
#import "PFSettingsVC.h"
#import "PFDetailVC.h"
#import "PFTagsVC.h"
#import "UIViewController+PFExtensions.h"
#import "PFCommentsVC.h"

@interface PFNavigationControllerDelegate ()

@property(nonatomic, assign) BOOL meLoaded;
@property(nonatomic, weak) UIViewController *currentViewController;

@end

@implementation PFNavigationControllerDelegate

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC; {
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated; {
    
    // we need to do the clear headers first
    
    if([viewController isKindOfClass:[PFCategoryFeedVC class]]) {
        
        PFCategoryFeedVC *vc = (PFCategoryFeedVC *)viewController;
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:[vc currentNavigationBarAlpha]];
        
        if([vc currentNavigationBarAlpha] == 0) {
            [[navigationController navigationBar] setAlpha:0.01f];
        }
        
        [self setCurrentViewController:viewController];
    }
    
    if([viewController isKindOfClass:[PFProfileVC class]]) {
        
        [[navigationController navigationBar] setAlpha:0.01];
        
        PFProfileVC *vc = (PFProfileVC *)viewController;
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:[vc currentNavigationBarAlpha]];
        
        if([vc currentNavigationBarAlpha] == 0) {
            [[navigationController navigationBar] setAlpha:0.01f];
        }
        
        [self setCurrentViewController:viewController];
    }
    
    if([viewController isKindOfClass:[PFMeVC class]]) {
        
        [[navigationController navigationBar] setAlpha:0.01];
        
        PFMeVC *vc = (PFMeVC *)viewController;
        
        [[navigationController navigationBar] setAlpha:[vc currentNavigationBarAlpha]];
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        
        if([vc currentNavigationBarAlpha] == 0) {
            [[navigationController navigationBar] setAlpha:0.01f];
        }
        
        [self setCurrentViewController:viewController];
    }
    
    // handle the view controllers that branch from the clear headers
    
    if([viewController isKindOfClass:[PFMessagesVC class]]) {
        
        if([viewController isPushingToClearHeader]) {
            
            [self showShim:viewController nc:navigationController];
            
        } else if([viewController isBeingPushedFromClearHeader] &&
                  [self currentViewController] != nil) {
            
            [[navigationController navigationBar] setAlpha:0.01];
            [self setCurrentViewController:nil];
        }
    }
    
    if([viewController isKindOfClass:[PFNotificationsVC class]]) {
        
        if([viewController isPushingToClearHeader]) {
            
            [self showShim:viewController nc:navigationController];
            
        } else if([viewController isBeingPushedFromClearHeader] &&
                  [self currentViewController] != nil) {
            
            [[navigationController navigationBar] setAlpha:0.01];
            [self setCurrentViewController:nil];
        }
    }
    
    if([viewController isKindOfClass:[PFDetailVC class]]) {
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        
        if([viewController isPushingToClearHeader]) {
            
            [self showShim:viewController nc:navigationController];
            
        } else if([viewController isBeingPushedFromClearHeader] &&
                  [self currentViewController] != nil) {
            
            [[navigationController navigationBar] setAlpha:0.01];
            [self setCurrentViewController:nil];
        }
    }
    
    if([viewController isKindOfClass:[PFCommentsVC class]]) {
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        
        if([viewController isPushingToClearHeader]) {
            
            [self showShim:viewController nc:navigationController];
            
        } else if([viewController isBeingPushedFromClearHeader] &&
                  [self currentViewController] != nil) {
            
            [[navigationController navigationBar] setAlpha:0.01];
            [self setCurrentViewController:nil];
        }
    }
    
    // continue normally
    
    if([viewController isKindOfClass:[PFDiscoverVC class]]) {

        [[navigationController navigationBar] restyleNavigationBarTranslucentWhite];
    }

    if([viewController isKindOfClass:[PFNetworkVC class]]) {
        
        [self showShim:viewController nc:navigationController];
    }
    
    if([viewController isKindOfClass:[PFThreadVC class]]) {
        
        [self showShim:viewController nc:navigationController];
    }
    
    if([viewController isKindOfClass:[PFUsersVC class]]) {
        
        [self showShim:viewController nc:navigationController];
    }
    
    if([viewController isKindOfClass:[PFSearchResultsVC class]]) {
        
        [self showShim:viewController nc:navigationController];
    }
    
    if([viewController isKindOfClass:[PFEditProfileVC class]]) {
        
        [[navigationController navigationBar] restyleNavigationBarSolidBlack];
        [[navigationController navigationBar] setAlpha:0.01f];
    }
    
    if([viewController isKindOfClass:[PFSettingsVC class]]) {
        
        [[navigationController navigationBar] restyleNavigationBarSolidBlack];
        [[navigationController navigationBar] setAlpha:0.01];
    }
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated; {
    
    if([viewController isKindOfClass:[PFHomeFeedVC class]]) {
        
        [self hideShim:viewController];
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:1.0f];
    }
    
    if([viewController isKindOfClass:[PFTagsVC class]]) {
        
        [self hideShim:viewController];
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:1.0f];
    }
    
    if([viewController isKindOfClass:[PFCommentsVC class]]) {
        
        [self hideShim:viewController];
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:1.0f];
    }
    
    if([viewController isKindOfClass:[PFMessagesVC class]]) {
        
        [self hideShim:viewController];
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:1.0f];
    }
    
    if([viewController isKindOfClass:[PFNotificationsVC class]]) {
        
        [self hideShim:viewController];
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:1.0f];
    }

    if([viewController isKindOfClass:[PFDiscoverVC class]]) {
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentWhite];
    }
    
    if([viewController isKindOfClass:[PFNetworkVC class]]) {
        
        [self hideShim:viewController];
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:1];
    }
    
    if([viewController isKindOfClass:[PFThreadVC class]]) {
        
        [self hideShim:viewController];
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:1.0f];
    }
    
    if([viewController isKindOfClass:[PFUsersVC class]]) {
        
        [self hideShim:viewController];
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:1.0f];
    }
    
    if([viewController isKindOfClass:[PFNotificationsVC class]]) {
        
        [self hideShim:viewController];
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:1.0f];
    }
    
    if([viewController isKindOfClass:[PFSearchResultsVC class]]) {
        
        [self hideShim:viewController];
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentWhite];
        [[navigationController navigationBar] setAlpha:1.0f];
    }
    
    if([viewController isKindOfClass:[PFEditProfileVC class]]) {
        
        [[navigationController navigationBar] restyleNavigationBarSolidBlack];
        [[navigationController navigationBar] setAlpha:1.0f];
    }
    
    if([viewController isKindOfClass:[PFSettingsVC class]]) {
        
        [[navigationController navigationBar] restyleNavigationBarSolidBlack];
        [[navigationController navigationBar] setAlpha:1.0f];
    }
}

- (void)showShim:(UIViewController *)viewController nc:(UINavigationController *)nc; {
 
    if ([viewController conformsToProtocol:@protocol(PFShimmedViewController)]) {

        if([[nc navigationBar] alpha] < 1) {
            
            id<PFShimmedViewController> vc = (id<PFShimmedViewController>)viewController;
    
            if([vc shimmed]) {
                
                [vc showShim];
                [vc setShimmed:NO];
            }
        }
    }
}

- (void)hideShim:(UIViewController *)viewController; {
    
    if ([viewController conformsToProtocol:@protocol(PFShimmedViewController)]) {
        
        id<PFShimmedViewController> vc = (id<PFShimmedViewController>)viewController;

        [vc hideShim];
    }
}

@end
