//
//  UITabBarController+PFExtensions.h
//  Portfolium
//
//  Created by John Eisberg on 7/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITabBarController (PFExtentions)

- (BOOL)isTabBarHidden;
    
- (void)setTabBarHidden:(BOOL)hidden;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)setMainTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
