//
//  PFRootNavigationController.m
//  Portfolium
//
//  Created by John Eisberg on 10/21/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFNavigationController.h"
#import "PFNavigationControllerDelegate.h"
#import "PFShimmedViewController.h"
#import "PFDetailVC.h"

@interface PFNavigationController ()

@property(nonatomic, strong) PFNavigationControllerDelegate *strongDelegate;

@end

@implementation PFNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    PFNavigationControllerDelegate *delegate =
    [[PFNavigationControllerDelegate alloc] init];
    
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

- (void)pushDetailVC:(PFDetailVC *)vc
            animated:(BOOL)animated; {
    
    [self pushViewController:vc animated:animated];
}

@end
