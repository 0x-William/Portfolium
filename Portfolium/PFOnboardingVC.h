//
//  PFOnboardingVC.h
//  Portfolium
//
//  Created by John Eisberg on 7/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFTabbedVC.h"

@class PFNavigationControllerDelegate;

@interface PFOnboardingVC : PFTabbedVC

@property(nonatomic, strong) PFNavigationControllerDelegate *navigationControllerDelegate;

+ (PFOnboardingVC *)shared;

+ (PFOnboardingVC *)_new;

- (UIButton *)buildTabbarButton:(NSInteger)index;

@end
