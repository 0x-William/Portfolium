//
//  PFLandingNavigationController.h
//  Portfolium
//
//  Created by John Eisberg on 10/21/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFShimmedViewController.h"

@class PFDetailVC;

@interface PFLandingNavigationController : UINavigationController<UIGestureRecognizerDelegate>

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
                      shim:(id<PFShimmedViewController>)shim;

@end
