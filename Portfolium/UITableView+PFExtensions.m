//
//  UITableView+PFExtensions.m
//  Portfolium
//
//  Created by John Eisberg on 9/3/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "UITableView+PFExtensions.h"

@implementation UITableView (ASExtensions)

- (void)hidesLastSeparator; {
}

- (void)setSeparatorInsetZero; {
    
    if([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    } else {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
}

@end
