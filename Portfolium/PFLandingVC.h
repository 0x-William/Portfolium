//
//  PFLandingVC.h
//  Portfolium
//
//  Created by John Eisberg on 7/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTabbedVC.h"

@class PFLandingNavigationControllerDelegate;

@interface PFLandingVC : PFTabbedVC

@property(nonatomic, strong) UITabBarController *tabBarController;
@property(nonatomic, strong) PFLandingNavigationControllerDelegate *strongDelegate;
@property(nonatomic, strong) UINavigationController *introNC;

+ (PFLandingVC *)shared;
+ (PFLandingVC *)_new;

- (void)pushJoinVC;

@end
