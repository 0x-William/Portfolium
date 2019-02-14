//
//  UIView+PFExtensions.m
//  Portfolium
//
//  Created by John Eisberg on 10/7/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "UIView+PFExtensions.h"

@implementation UIView (ASExtensions)

- (void)disableScrollsToTopPropertyOnAllSubviews; {
 
    if ([self isKindOfClass:[UIScrollView class]])
        ((UIScrollView *)self).scrollsToTop = NO;
    
    for (UIView *view in [self subviews])
        [view disableScrollsToTopPropertyOnAllSubviews];
}

@end
