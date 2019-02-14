//
//  PFDetailImageViewItem.m
//  Portfolium
//
//  Created by John Eisberg on 12/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFDetailImageViewItem.h"
#import "PFConstraints.h"
#import "UIColor+PFEntensions.h"
#import "PFEntryView.h"

@implementation PFDetailImageViewItem

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFDetailImageViewItem";
}

- (id)initWithFrame:(CGRect)frame; {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIView *palateView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [palateView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [palateView setUserInteractionEnabled:YES];
        [[self contentView] addSubview:palateView];
        [self setPalateView:palateView];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:palateView
                                                      toHeightOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints constrainView:palateView
                                                       toWidthOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints leftAlignView:palateView
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:0.0f],
                                             
                                             [PFConstraints topAlignView:palateView
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:0.0f],
                                             ]];
        
        UIImageView *mediaView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [mediaView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [mediaView setContentMode:UIViewContentModeScaleAspectFit];
        [mediaView setClipsToBounds:YES];
        [mediaView setBackgroundColor:[UIColor blackColor]];
        [mediaView setUserInteractionEnabled:YES];
        [[self contentView] addSubview:mediaView];
        [self setMediaView:mediaView];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self mediaView]
                                                      toHeightOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints constrainView:[self mediaView]
                                                                  toWidthOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints leftAlignView:[self mediaView]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:0.0f],
                                             
                                             [PFConstraints topAlignView:[self mediaView]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:0.0f],
                                             ]];
    }
    
    return self;
}

@end
