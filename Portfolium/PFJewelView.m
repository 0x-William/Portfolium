//
//  PFJewelView.m
//  Portfolium
//
//  Created by John Eisberg on 12/18/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFJewelView.h"
#import "PFFont.h"
#import "PFColor.h"
#import "UIColor+PFEntensions.h"
#import "PFConstraints.h"

static const CGFloat kStandardHeight = 20.0f;

@implementation PFJewelView

- (id)initWithFrame:(CGRect)frame; {
    
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor redColor]];
        [self setFrame:CGRectMake(15, -4, kStandardHeight, kStandardHeight)];
        
        [[self layer] setCornerRadius:(kStandardHeight / 2)];
        [[self layer] setMasksToBounds:YES];
        
        [[self layer] setBorderColor:[[UIColor colorWithHexString:[PFColor defaultTabBarColor]] CGColor]];
        [[self layer] setBorderWidth:1.0];
        
        UILabel *count = [[UILabel alloc] initWithFrame:CGRectZero];
        [count setTranslatesAutoresizingMaskIntoConstraints:NO];
        [count setClipsToBounds:YES];
        [count setBackgroundColor:[UIColor clearColor]];
        [count setFont:[PFFont boldFontOfSmallestSize]];
        [count setTextColor:[UIColor whiteColor]];
        [count setTextAlignment:NSTextAlignmentCenter];
        [count setNumberOfLines:1];
        [self addSubview:count];
        [self setCount:count];
        
        [self addConstraints:@[[PFConstraints constrainView:count
                                                   toHeight:kStandardHeight],
                               
                               [PFConstraints constrainView:count
                                                    toWidth:kStandardHeight],
                               
                               [PFConstraints leftAlignView:count
                                        relativeToSuperView:self
                                       withDistanceFromEdge:0.0f],
                               
                               [PFConstraints topAlignView:count
                                       relativeToSuperView:self
                                      withDistanceFromEdge:0.0f],
                               ]];
    }
    
    return self;
}

- (void)pop; {
    
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounceInAnimationStopped)];
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView commitAnimations];
}

- (void)bounceInAnimationStopped; {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounceOutAnimationStopped)];
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounceOutAnimationStopped; {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    self.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

@end
