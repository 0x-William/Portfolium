//
//  PFSwipeNavigationController.m
//  Portfolium
//
//  Created by John Eisberg on 10/21/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFSwipeNavigationController.h"
#import "PFSwipeNavigationControllerDelegate.h"

@interface PFSwipeNavigationController ()

@property(nonatomic, strong) PFSwipeNavigationControllerDelegate *strongDelegate;

@end

@implementation PFSwipeNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    PFSwipeNavigationControllerDelegate *delegate =
    [[PFSwipeNavigationControllerDelegate alloc] init];
    
    [self setStrongDelegate:delegate];
    [self setDelegate:delegate];
}

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
                      shim:(id<PFShimmedViewController>)shim; {
    
    [shim showShim];
    [shim setShimmed:YES];
    
    [self pushViewController:viewController animated:animated];
}

@end
