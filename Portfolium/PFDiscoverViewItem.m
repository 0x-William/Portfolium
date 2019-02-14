//
//  PFDiscoverViewItem.m
//  Portfolium
//
//  Created by John Eisberg on 8/7/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFDiscoverViewItem.h"
#import "PFFont.h"
#import "PFConstraints.h"

@implementation PFDiscoverViewItem

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFCategoriesViewItem";
}

- (id)initWithFrame:(CGRect)frame; {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
        [self setBackgroundView:[self imageView]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [label setNumberOfLines:0];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setFont:[PFFont systemFontOfSmallSize]];
        [label setTextColor:[UIColor whiteColor]];
        [[self contentView] addSubview:label];
        [self setLabel:label];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self label]
                                                       toWidthOfSuperView:[self contentView]
                                                              withPadding:3.0f],
                                             
                                             [PFConstraints leftAlignView:[self label]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:4.0f],
                                             
                                             [PFConstraints bottomAlignView:[self label]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:4.0f],
                                             ]];
    }
    
    return self;
}

@end
