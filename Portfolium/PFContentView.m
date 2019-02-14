//
//  PFContentView.m
//  Portfolium
//
//  Created by John Eisberg on 7/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFContentView.h"
#import "PFConstraints.h"
#import "PFActivityIndicatorView.h"
#import "PFColor.h"

@interface PFContentView ()

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) NSArray *contentViewConstraints;

@end

@implementation PFContentView

- (void)setContentView:(UIView *)contentView; {
    
    if (_contentView != nil) {
        
        [_contentView removeFromSuperview];
        [self removeConstraints:[self contentViewConstraints]];
    }
    
    _contentView = contentView;
    
    [self setContentViewConstraints:@[[PFConstraints constrainView:contentView
                                                toWidthOfSuperView:self
                                                       withPadding:0.0f],
                                      
                                      [PFConstraints leftAlignView:contentView
                                               relativeToSuperView:self
                                              withDistanceFromEdge:0.0f],
                                      
                                      [PFConstraints topAlignView:contentView
                                              relativeToSuperView:self
                                             withDistanceFromEdge:0.0f],
                                      
                                      [PFConstraints constrainView:contentView
                                                          toHeight:[[UIScreen mainScreen]
                                                                    bounds].size.height + [self contentOffset]]
                                      ]];
    
    [self addSubview:contentView];
    [self sendSubviewToBack:contentView];
    [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[self contentViewConstraints]];
    
    [self setSpinner:[PFActivityIndicatorView windowIndicatorView]];
    [contentView addSubview:[self spinner]];
}

@end
