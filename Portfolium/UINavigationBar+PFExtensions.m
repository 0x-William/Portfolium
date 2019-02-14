//
//  UINavigationController+PFExtensions.m
//  Portfolium
//
//  Created by John Eisberg on 7/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "UINavigationBar+PFExtensions.h"
#import "PFColor.h"
#import "PFStatusBar.h"
#import "PFFont.h"

@implementation UINavigationBar (PFExtentions)

- (void)restyleNavigationBarClear; {
    
    [self setBarStyle:UIBarStyleBlackTranslucent];
    [self setShadowImage:[UIImage new]];
    [self setBackgroundImage:[PFColor imageOfColor:[UIColor clearColor]]
               forBarMetrics:UIBarMetricsDefault];
}

- (void)restyleNavigationBarSolidBlack; {
    
    [PFStatusBar statusBarWhite];
    
    [self setBarStyle:UIBarStyleDefault];
    [self setTranslucent:NO];
    [self setBackgroundImage:[PFColor imageOfColor:[UIColor blackColor]]
               forBarMetrics:UIBarMetricsDefault];
    
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                   NSFontAttributeName:[PFFont systemFontOfLargeSize]}];
}

- (void)restyleNavigationBarTranslucentBlack; {
    
    [PFStatusBar statusBarWhite];
    
    [self setBarStyle:UIBarStyleDefault];
    [self setTranslucent:YES];
    [self setBackgroundImage:[PFColor imageOfColor:[PFColor blackColorOpaque]]
               forBarMetrics:UIBarMetricsDefault];
    
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                   NSFontAttributeName:[PFFont systemFontOfLargeSize]}];
    
    [PFStatusBar statusBarWhite];
}

- (void)restyleNavigationBarSolidWhite; {
    
    [self setBarStyle:UIBarStyleDefault];
    [self setTranslucent:NO];
    [self setBackgroundImage:[PFColor imageOfColor:[UIColor whiteColor]]
               forBarMetrics:UIBarMetricsDefault];
    
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                   NSFontAttributeName:[PFFont systemFontOfLargeSize]}];
    
    [PFStatusBar statusBarDefault];
}

- (void)restyleNavigationBarTranslucentWhite; {
    
    [self setBarStyle:UIBarStyleDefault];
    [self setTranslucent:YES];
    [self setBackgroundImage:[PFColor imageOfColor:[UIColor whiteColor]]
               forBarMetrics:UIBarMetricsDefault];
    
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                   NSFontAttributeName:[PFFont systemFontOfLargeSize]}];
    
    [PFStatusBar statusBarDefault];
}

@end
