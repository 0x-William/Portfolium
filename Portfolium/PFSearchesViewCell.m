//
//  PFSearchesViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 8/19/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFSearchesViewCell.h"
#import "TTTAttributedLabel.h"
#import "PFFont.h"
#import "PFConstraints.h"

@implementation PFSearchesViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFSearchesViewCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIImageView *glass = [[UIImageView alloc] initWithFrame:CGRectZero];
        [glass setBackgroundColor:[UIColor greenColor]];
        [glass setTranslatesAutoresizingMaskIntoConstraints:NO];
        [glass setUserInteractionEnabled:YES];
        [[self contentView] addSubview:glass];
        
        TTTAttributedLabel *searchLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [searchLabel setTextAlignment:NSTextAlignmentLeft];
        [searchLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [searchLabel setFont:[PFFont fontOfMediumSize]];
        [[self contentView] addSubview:searchLabel];
        [self setSearchLabel:searchLabel];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:glass
                                                                 toHeight:50.0f],
                                             
                                             [PFConstraints constrainView:glass
                                                                  toWidth:50.0f],
                                             
                                             [PFConstraints leftAlignView:glass
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:12.0f],
                                             
                                             [PFConstraints topAlignView:glass
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:12.0f],
                                             
                                             [PFConstraints constrainView:[self searchLabel]
                                                                 toHeight:40.0f],
                                             
                                             [PFConstraints constrainView:[self searchLabel]
                                                                  toWidth:247.0f],
                                             
                                             [PFConstraints leftAlignView:[self searchLabel]
                                                      relativeToSuperView:glass
                                                     withDistanceFromEdge:55.0f],
                                             
                                             [PFConstraints topAlignView:[self searchLabel]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:0.0f],
                                             ]];
    }
    
    return self;
}

@end
