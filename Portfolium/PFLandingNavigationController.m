//
//  PFLandingNavigationController.m
//  Portfolium
//
//  Created by John Eisberg on 10/21/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFLandingNavigationController.h"
#import "PFLandingNavigationControllerDelegate.h"
#import "PFDetailVC.h"

@interface PFLandingNavigationController ()

@property(nonatomic, strong) PFLandingNavigationControllerDelegate *strongDelegate;

@end

@implementation PFLandingNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    PFLandingNavigationControllerDelegate *delegate =
    [[PFLandingNavigationControllerDelegate alloc] init];
    
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
