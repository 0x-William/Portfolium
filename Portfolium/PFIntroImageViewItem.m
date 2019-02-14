//
//  PFIntroViewItem.m
//  Portfolium
//
//  Created by John Eisberg on 12/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFIntroImageViewItem.h"
#import "PFConstraints.h"
#import "UIColor+PFEntensions.h"
#import "PFEntryView.h"

@implementation PFIntroImageViewItem

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFIntroImageViewItem";
}

- (id)initWithFrame:(CGRect)frame; {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        [imageView setBackgroundColor:[UIColor blackColor]];
        [imageView setUserInteractionEnabled:YES];
        [[self contentView] addSubview:imageView];
        [self setImageView:imageView];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self imageView]
                                                      toHeightOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints constrainView:[self imageView]
                                                       toWidthOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints leftAlignView:[self imageView]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:0.0f],
                                             
                                             [PFConstraints topAlignView:[self imageView]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:0.0f],
                                             ]];
    }
    
    return self;
}

@end