//
//  PFTabbedVC.h
//  Portfolium
//
//  Created by John Eisberg on 7/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFTabbedVC : UIViewController<UITabBarControllerDelegate>

@property (strong, nonatomic) UITabBarController *tabBarController;

- (UIButton *)buildTabbarButton:(NSInteger)index;
- (void)tabBarAction:(UIButton *)tabBarButton;
- (void)tabBarDeselect;

@end
