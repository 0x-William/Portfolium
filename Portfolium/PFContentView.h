//
//  PFContentView.h
//  Portfolium
//
//  Created by John Eisberg on 7/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFActivityIndicatorView;

@interface PFContentView : UIView

@property(nonatomic, strong) PFActivityIndicatorView *spinner;
@property(nonatomic, assign) CGFloat contentOffset;

- (void)setContentView:(UIView *)contentView;

@end
