//
//  PFAppContainerVC.h
//  Portfolium
//
//  Created by John Eisberg on 6/19/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PFAppContainerAnimation) {
    
    PFAppContainerAnimationNone,
    PFAppContainerAnimationSlideUp,
    PFAppContainerAnimationSlideDown,
    PFAppContainerAnimationSlideLeft,
};

@interface PFAppContainerVC : UIViewController<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

+ (PFAppContainerVC *)shared;

- (void)setRootViewController:(UIViewController *)root
                    animation:(PFAppContainerAnimation)animation;

- (void)setRootViewController:(UIViewController *)root;
- (void)setDefaultRootViewControllerWithAnimation:(PFAppContainerAnimation)animation;
- (void)setDefaultRootViewController;

- (void)closeMenuAnimated:(bool)animated;

- (void)openMenuAction;

@property (nonatomic, strong) UIViewController *rootViewController;

@end