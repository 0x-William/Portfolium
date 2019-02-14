//
//  PFSearchResultsView.h
//  Portfolium
//
//  Created by John Eisberg on 8/19/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFActivityIndicatorView;
@class PFSearchResultsVC;

@interface PFSearchResultsView : UIView

@property(nonatomic, strong) PFActivityIndicatorView *spinner;
@property(nonatomic, strong) UIButton *entriesButton;
@property(nonatomic, strong) UIButton *connectionsButton;
@property(nonatomic, assign) CGFloat contentOffset;
@property(nonatomic, strong) UIView *identifier;

- (id)initWithFrame:(CGRect)frame delegate:(PFSearchResultsVC *)delegate;
- (void)setContentView:(UIView *)contentView;

@end
