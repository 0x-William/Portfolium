//
//  PFLandingNavigationControllerDelegate.m
//  Portfolium
//
//  Created by John Eisberg on 10/21/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFLandingNavigationControllerDelegate.h"
#import "PFLandingCategoryFeedVC.h"
#import "PFLandingDetailVC.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFCommentsVC.h"
#import "PFLandingProfileVC.h"
#import "PFJoinVC.h"
#import "PFJoinEmailVC.h"
#import "PFLoginVC.h"
#import "PFLandingTagsVC.h"
#import "UIViewController+PFExtensions.h"

@interface PFLandingNavigationControllerDelegate ()

@property(nonatomic, weak) UIViewController *currentViewController;

@end


@implementation PFLandingNavigationControllerDelegate

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
    
    if([viewController isKindOfClass:[PFLandingCategoryFeedVC class]]) {
        
        PFCategoryFeedVC *vc = (PFCategoryFeedVC *)viewController;
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:[vc currentNavigationBarAlpha]];
        
        if([vc currentNavigationBarAlpha] == 0) {
            [[navigationController navigationBar] setAlpha:0.01f];
        }
        
        [self setCurrentViewController:viewController];
    }
    
    if([viewController isKindOfClass:[PFLandingProfileVC class]]) {
        
        [[navigationController navigationBar] setAlpha:0.01];
        
        PFProfileVC *vc = (PFProfileVC *)viewController;
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:[vc currentNavigationBarAlpha]];
        
        if([vc currentNavigationBarAlpha] == 0) {
            [[navigationController navigationBar] setAlpha:0.01f];
        }
        
        [self setCurrentViewController:viewController];
    }
    
    // handle the view controllers that branch from the clear headers
    
    if([viewController isKindOfClass:[PFLandingDetailVC class]]) {
        
        if([viewController isPushingToClearHeader]) {
            
            [self showShim:viewController nc:navigationController];
            
        } else if([viewController isBeingPushedFromClearHeader] &&
                  [self currentViewController] != nil) {
            
            [[navigationController navigationBar] setAlpha:0.01];
            [self setCurrentViewController:nil];
        }
    }
    
    if([viewController isKindOfClass:[PFCommentsVC class]]) {
        
        if([viewController isPushingToClearHeader]) {
            
            [self showShim:viewController nc:navigationController];
            
        } else if([viewController isBeingPushedFromClearHeader] &&
                  [self currentViewController] != nil) {
            
            [[navigationController navigationBar] setAlpha:0.01];
            [self setCurrentViewController:nil];
        }
    }
    
    // tab bar headers
    
    if([viewController isKindOfClass:[PFJoinVC class]]) {
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:0.01f];
    }
    
    if([viewController isKindOfClass:[PFJoinEmailVC class]]) {
        
        [[navigationController navigationBar] restyleNavigationBarSolidBlack];
        [[navigationController navigationBar] setAlpha:0.01f];
    }
    
    if([viewController isKindOfClass:[PFLoginVC class]]) {
        
        [[navigationController navigationBar] restyleNavigationBarSolidBlack];
        [[navigationController navigationBar] setAlpha:0.01f];
    }
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated; {
    
    // tab bar headers
    
    if([viewController isKindOfClass:[PFJoinEmailVC class]]) {
        
        [[navigationController navigationBar] restyleNavigationBarSolidBlack];
        [[navigationController navigationBar] setAlpha:1.0f];
    }
    
    if([viewController isKindOfClass:[PFJoinVC class]]) {
        
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:0.01f];
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
