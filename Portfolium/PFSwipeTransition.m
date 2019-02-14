//
//  PFSwipeTransition.m
//  Portfolium
//
//  Created by John Eisberg on 7/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFSwipeTransition.h"

#import "PFSwipeTransition.h"

static CGFloat const kChildViewPadding = 0;
static CGFloat const kDamping = 0.7f;
static CGFloat const kInitialSpringVelocity = 0.5f;

@implementation PFSwipeTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext; {
    
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext; {
    
    UIViewController* toViewController = [transitionContext viewControllerForKey:
                                          UITransitionContextToViewControllerKey];
    
    UIViewController* fromViewController = [transitionContext viewControllerForKey:
                                            UITransitionContextFromViewControllerKey];
    
    CGFloat travelDistance = [transitionContext containerView].bounds.size.width + kChildViewPadding;
    CGAffineTransform travel = CGAffineTransformMakeTranslation ([self pop] ? travelDistance : -travelDistance, 0);
    
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    toViewController.view.transform = CGAffineTransformInvert (travel);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0
         usingSpringWithDamping:kDamping
          initialSpringVelocity:kInitialSpringVelocity
                        options:0x00
                     animations:^{
                         
                         fromViewController.view.transform = travel;
                         fromViewController.view.alpha = 0;
                         toViewController.view.transform = CGAffineTransformIdentity;
                         toViewController.view.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         
                         fromViewController.view.transform = CGAffineTransformIdentity;
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
