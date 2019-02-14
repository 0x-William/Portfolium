//
//  UITabBarController+PFExtensions.m
//  Portfolium
//
//  Created by John Eisberg on 7/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "UITabBarController+PFExtensions.h"

@implementation UITabBarController (PFExtentions)

- (BOOL)isTabBarHidden; {
  
    CGRect viewFrame = CGRectApplyAffineTransform(self.view.frame, self.view.transform);
    CGRect tabBarFrame = self.tabBar.frame;
    return tabBarFrame.origin.y >= viewFrame.size.height;
}

- (void)setTabBarHidden:(BOOL)hidden; {
    
    [self setTabBarHidden:hidden animated:NO];
}


- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated; {
    
    BOOL isHidden = [self isTabBarHidden];
    
    if (hidden == isHidden) {
        return;
    }
    
    UIView* transitionView = [self.view.subviews objectAtIndex:0];
    
    if (!transitionView) {
        return;
    }
    
    CGRect viewFrame = CGRectApplyAffineTransform(self.view.frame, self.view.transform);
    CGRect tabBarFrame = self.tabBar.frame;
    CGRect containerFrame = transitionView.frame;
    tabBarFrame.origin.y = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height - 32.0f);
    containerFrame.size.height = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height + 32.0f);
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.tabBar.frame = tabBarFrame;
                         transitionView.frame = containerFrame;
                     }
     ];
}

- (void)setMainTabBarHidden:(BOOL)hidden animated:(BOOL)animated; {
    
    BOOL isHidden = [self isTabBarHidden];
    
    if (hidden == isHidden) {
        return;
    }
    
    UIView* transitionView = [self.view.subviews objectAtIndex:0];
    
    if (!transitionView) {
        return;
    }
    
    CGRect viewFrame = CGRectApplyAffineTransform(self.view.frame, self.view.transform);
    CGRect tabBarFrame = self.tabBar.frame;
    CGRect containerFrame = transitionView.frame;
    tabBarFrame.origin.y = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height);
    containerFrame.size.height = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height);
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.tabBar.frame = tabBarFrame;
                         transitionView.frame = containerFrame;
                     }
     ];
}

@end
