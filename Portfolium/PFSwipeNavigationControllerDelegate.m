//
//  PFSwipeNavigationControllerDelegate.m
//  Portfolium
//
//  Created by John Eisberg on 10/21/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFSwipeNavigationControllerDelegate.h"
#import "PFSwipeTransition.h"
#import "PFLandingProfileVC.h"
#import "PFJoinVC.h"
#import "PFJoinEmailVC.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFLoginVC.h"
#import "PFIntroVC.h"
#import "PFIntro2VC.h"
#import "PFForgotPasswordVC.h"

@implementation PFSwipeNavigationControllerDelegate

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC; {
    
    if(![toVC isKindOfClass:[PFJoinVC class]] &&
       ![toVC isKindOfClass:[PFJoinEmailVC class]] &&
       ![toVC isKindOfClass:[PFLoginVC class]] &&
       ![toVC isKindOfClass:[PFForgotPasswordVC class]]) {
    
        if(operation == UINavigationControllerOperationPush) {
            
            return [[PFSwipeTransition alloc] init];
            
        } else {
            
            PFSwipeTransition *transition = [[PFSwipeTransition alloc] init];
            [transition setPop:YES];
            return transition;
        }
    }
    
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated; {
    

    if([viewController isKindOfClass:[PFJoinVC class]]) {
        
        [navigationController setNavigationBarHidden:YES animated:NO];
    }
    
    if([viewController isKindOfClass:[PFJoinEmailVC class]]) {
        
        [navigationController setNavigationBarHidden:NO animated:NO];
        [[navigationController navigationBar] restyleNavigationBarSolidBlack];
        [[navigationController navigationBar] setAlpha:0.01f];
    }
    
    if([viewController isKindOfClass:[PFLoginVC class]]) {
        
        [[navigationController navigationBar] restyleNavigationBarSolidBlack];
        [[navigationController navigationBar] setAlpha:1.0f];
        [[navigationController navigationItem] setHidesBackButton:YES];
    }
    
    if([viewController isKindOfClass:[PFIntroVC class]]) {
        
        [navigationController setNavigationBarHidden:NO animated:NO];
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:0.01f];
    }
    
    if([viewController isKindOfClass:[PFIntro2VC class]]) {
        
        [navigationController setNavigationBarHidden:NO animated:NO];
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:0.01f];
    }
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated; {
    
    if([viewController isKindOfClass:[PFJoinVC class]]) {
        
        [navigationController setNavigationBarHidden:YES animated:NO];
    }
    
    if([viewController isKindOfClass:[PFJoinEmailVC class]]) {
        
        [navigationController setNavigationBarHidden:NO animated:NO];
        [[navigationController navigationBar] restyleNavigationBarSolidBlack];
        [[navigationController navigationBar] setAlpha:1.0f];
    }
    
    if([viewController isKindOfClass:[PFLoginVC class]]) {
        
        [[navigationController navigationBar] restyleNavigationBarSolidBlack];
        [[navigationController navigationBar] setAlpha:1.0f];
        [[navigationController navigationItem] setHidesBackButton:YES];
    }
    
    if([viewController isKindOfClass:[PFIntroVC class]]) {
        
        [navigationController setNavigationBarHidden:NO animated:NO];
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:0.01f];
    }
    
    if([viewController isKindOfClass:[PFIntro2VC class]]) {
        
        [navigationController setNavigationBarHidden:NO animated:NO];
        [[navigationController navigationBar] restyleNavigationBarTranslucentBlack];
        [[navigationController navigationBar] setAlpha:0.01f];
    }
}

@end
