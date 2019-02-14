//
//  UIViewController+PFExtensions.h
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (PFExtentions)

- (BOOL)isPushingViewController;

- (void)setUpImageBackButton;

- (void)setUpImageBackButtonForShim;

- (void)setUpImageBackButtonBlack;

- (void)setUpImageBackButtonClear;

- (void)setUpImageDismissButton;

- (void)setContentViewBelowNavigationBar:(UITableView *)tableView;

- (CGFloat)applicationFrameOffset;

- (UIViewController *)viewControllerBelow;

- (BOOL)isPushingToClearHeader;

- (BOOL)isBeingPushedFromClearHeader;

- (void)mailButtonAction:(UIButton *)button;

- (void)bellButtonAction:(UIButton *)button;

@end
