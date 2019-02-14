//
//  UIViewController+PFExtensions.m
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "UIViewController+PFExtensions.h"
#import "PFImage.h"
#import "PFMessagesVC.h"
#import "PFNotificationsVC.h"
#import "PFProfileVC.h"
#import "PFCategoryFeedVC.h"
#import "PFMeVC.h"
#import "FAKFontAwesome.h"
#import "PFColor.h"

@implementation UIViewController (PFExtentions)

- (BOOL)isPushingViewController; {
    
    BOOL pushing = NO;
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        pushing = YES;
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        pushing = NO;
    }
    
    return pushing;
}

- (void)setUpImageBackButton; {
    
    [self imageBackButton:[PFImage chevronBack]];
}

- (void)setUpImageBackButtonBlack; {
    
    [self imageBackButton:[PFImage chevronBackBlack]];
}

- (void)setUpImageBackButtonClear; {
    
    [self imageBackButton:nil];
}

- (void)imageBackButton:(UIImage *)image; {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 16, 34, 26)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [backButton setImage:image
                forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self
                   action:@selector(popCurrentViewController)
         forControlEvents:UIControlEventTouchUpInside];
    
    [[self navigationItem] setLeftBarButtonItem:barBackButtonItem];
}

- (void)setUpImageDismissButton; {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 16, 34, 26)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [backButton setImage:[PFImage chevronBack]
                forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self
                   action:@selector(dismissCurrentViewController)
         forControlEvents:UIControlEventTouchUpInside];
    
    [[self navigationItem] setLeftBarButtonItem:barBackButtonItem];
}

- (void)setUpImageBackButtonForShim; {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 16, 34, 26)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [backButton setImage:[PFImage chevronBack]
                forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self
                   action:@selector(popCurrentViewControllerShimmed)
         forControlEvents:UIControlEventTouchUpInside];
    
    [[self navigationItem] setLeftBarButtonItem:barBackButtonItem];
}

- (void)popCurrentViewControllerShimmed; {
    
    if([self isPoppingToClearHeader]) {
        
        if ([self conformsToProtocol:@protocol(PFShimmedViewController)]) {
            
            [(id)self showShim];
        }
    }
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)mailButtonAction:(UIButton *)button; {
    
    [[self navigationController] pushViewController:[PFMessagesVC _new]
                                           animated:YES];
}

- (void)bellButtonAction:(UIButton *)button; {
    
    [[self navigationController] pushViewController:[PFNotificationsVC _new]
                                           animated:YES];
}

- (void)popCurrentViewController; {
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)dismissCurrentViewController; {
    
    [[self navigationController] dismissViewControllerAnimated:YES completion:^{}];
}

- (void)setContentViewBelowNavigationBar:(UITableView *)tableView; {
    
    [tableView setContentInset:UIEdgeInsetsMake([self applicationFrameOffset], 0, 0, 0)];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
}

- (CGFloat)applicationFrameOffset; {
    
    CGFloat navigationBarHeight = [[self navigationController] navigationBar].frame.size.height;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    return navigationBarHeight + statusBarHeight;
}

- (UIViewController *)viewControllerBelow; {
    
    NSArray *array = [self.navigationController viewControllers];
    
    if([array count] > 1) {
        return [array objectAtIndex:[array count] - 2];
    } else {
        return nil;
    }
}

- (BOOL)isPoppingToClearHeader; {
    
    return ![self isPushingViewController] && [self viewControllerBelow] != nil &&
    ([[self viewControllerBelow] isKindOfClass:[PFProfileVC class]] ||
     [[self viewControllerBelow] isKindOfClass:[PFCategoryFeedVC class]] ||
     [[self viewControllerBelow] isKindOfClass:[PFMeVC class]]);
}

- (BOOL)isBeingPushedFromClearHeader; {
    
    return ([[self viewControllerBelow] isKindOfClass:[PFProfileVC class]] ||
     [[self viewControllerBelow] isKindOfClass:[PFCategoryFeedVC class]] ||
     [[self viewControllerBelow] isKindOfClass:[PFMeVC class]]);
}

- (BOOL)isPushingToClearHeader; {
    
    return [self isPushingViewController] &&
    ([[self viewControllerBelow] isKindOfClass:[PFProfileVC class]] ||
     [[self viewControllerBelow] isKindOfClass:[PFCategoryFeedVC class]] ||
     [[self viewControllerBelow] isKindOfClass:[PFMeVC class]]);
}

@end
