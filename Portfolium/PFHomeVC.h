//
//  PFHomeVC.h
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFEntry.h"

@interface PFHomeVC : UIViewController<UITabBarControllerDelegate>

@property(nonatomic, strong) UITabBarController *tabBarController;
@property(nonatomic, strong) UIButton *actionButton;

+ (PFHomeVC *)shared;
+ (PFHomeVC *)_new;

- (void)plusButtonAction;
- (void)goToNetworkTab;

- (void)gridButtonAction:(UIButton *)button;
- (void)dismissGridButtonAction;

- (void)launchAddEntry:(PFEntryType)entryType;
- (void)launchAddedEntry:(NSNumber *)entryId;

- (UIViewController *)viewControllerAtIndex:(NSInteger)index;

@end
