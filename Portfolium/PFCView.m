//
//  PFCView.m
//  Portfolium
//
//  Created by John Eisberg on 11/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFCView.h"
#import "PFConstraints.h"
#import "PFColor.h"

static NSString *kKeyPath = @"transform.translation.x";
static NSString *kKeyAnimation = @"shake";

@interface PFCView ()

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) NSArray *contentViewConstraints;
@property(nonatomic, assign) BOOL shaking;

@end

@implementation PFCView

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

- (void)shake; {
    
    if(![self shaking]) {
    
        [CATransaction begin];
        
        [self setShaking:YES];
        
        [CATransaction setCompletionBlock:^{
            [self setShaking:NO];
        }];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:kKeyPath];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.duration = 0.6;
        animation.values = @[ @(-8), @(8), @(-4), @(4), @(-2), @(2), @(-1), @(1), @(0) ];
        
        [self.layer addAnimation:animation forKey:kKeyAnimation];
        
        [CATransaction commit];
    }
}

@end
