//
//  PFSearchResultsView.m
//  Portfolium
//
//  Created by John Eisberg on 8/19/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFSearchResultsView.h"
#import "PFConstraints.h"
#import "PFActivityIndicatorView.h"
#import "PFSearchResultsVC.h"
#import "PFFont.h"
#import "PFColor.h"

@interface PFSearchResultsView ()

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) NSArray *contentViewConstraints;
@property(nonatomic, weak) PFSearchResultsVC *delegate;

@end

@implementation PFSearchResultsView

- (id)initWithFrame:(CGRect)frame delegate:(PFSearchResultsVC *)delegate; {
    
    self = [super initWithFrame:frame];
    
    if (self) {
    }
    
    return self;
}

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
}

@end
