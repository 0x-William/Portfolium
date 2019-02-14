//
//  PFAboutViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 12/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFEducationViewCell.h"
#import "PFConstraints.h"
#import "TTTAttributedLabel.h"
#import "PFFont.h"
#import "PFColor.h"

@implementation PFEducationViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFEducationViewCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setAvatarView:[[UIImageView alloc] initWithFrame:CGRectZero]];
        [[self imageView] setBackgroundColor:[UIColor yellowColor]];
        [[self imageView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self imageView] setContentMode:UIViewContentModeScaleAspectFit];
        [[self contentView] addSubview:[self imageView]];
        
        TTTAttributedLabel *headerLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [headerLabel setBackgroundColor:[UIColor greenColor]];
        [headerLabel setTextAlignment:NSTextAlignmentLeft];
        [headerLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [headerLabel setFont:[PFFont fontOfMediumSize]];
        [headerLabel setTextColor:[PFColor textFieldTextColor]];
        [[self contentView] addSubview:headerLabel];
        [self setHeaderLabel:headerLabel];
        
        TTTAttributedLabel *gpaLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [gpaLabel setBackgroundColor:[UIColor greenColor]];
        [gpaLabel setTextAlignment:NSTextAlignmentLeft];
        [gpaLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [gpaLabel setFont:[PFFont fontOfMediumSize]];
        [gpaLabel setTextColor:[PFColor textFieldTextColor]];
        [[self contentView] addSubview:gpaLabel];
        [self setGpaLabel:gpaLabel];
        
        TTTAttributedLabel *datesLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [datesLabel setBackgroundColor:[UIColor greenColor]];
        [datesLabel setTextAlignment:NSTextAlignmentLeft];
        [datesLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [datesLabel setFont:[PFFont fontOfMediumSize]];
        [datesLabel setTextColor:[PFColor textFieldTextColor]];
        [[self contentView] addSubview:datesLabel];
        [self setDatesLabel:datesLabel];
        
        TTTAttributedLabel *descriptionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [descriptionLabel setBackgroundColor:[UIColor whiteColor]];
        [descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [descriptionLabel setNumberOfLines:0];
        [descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [descriptionLabel setFont:[PFFont fontOfSmallSize]];
        [descriptionLabel setTextColor:[PFColor grayColor]];
        [[self contentView] addSubview:descriptionLabel];
        [self setDescriptionLabel:descriptionLabel];

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
                                             
                                             [PFConstraints constrainView:[self headerLabel]
                                                                 toHeight:20.0f],
                                             
                                             [PFConstraints constrainView:[self headerLabel]
                                                                  toWidth:227.0f],
                                             
                                             [PFConstraints leftAlignView:[self headerLabel]
                                                      relativeToSuperView:[self imageView]
                                                     withDistanceFromEdge:62.0f],
                                             
                                             [PFConstraints topAlignView:[self headerLabel]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:12.0f],
                                             
                                             [PFConstraints constrainView:[self gpaLabel]
                                                                 toHeight:20.0f],
                                             
                                             [PFConstraints constrainView:[self gpaLabel]
                                                                  toWidth:227.0f],
                                             
                                             [PFConstraints leftAlignView:[self gpaLabel]
                                                      relativeToSuperView:[self imageView]
                                                     withDistanceFromEdge:62.0f],
                                             
                                             [PFConstraints positionView:[self gpaLabel]
                                                               belowView:[self headerLabel]
                                                              withMargin:0.0f],
                                             
                                             [PFConstraints constrainView:[self datesLabel]
                                                                 toHeight:20.0f],
                                             
                                             [PFConstraints constrainView:[self datesLabel]
                                                                  toWidth:227.0f],
                                             
                                             [PFConstraints leftAlignView:[self datesLabel]
                                                      relativeToSuperView:[self imageView]
                                                     withDistanceFromEdge:62.0f],
                                             
                                             [PFConstraints positionView:[self datesLabel]
                                                               belowView:[self gpaLabel]
                                                              withMargin:0.0f],
                                             
                                             [PFConstraints constrainView:[self descriptionLabel]
                                                                 toHeight:20.0f],
                                             
                                             [PFConstraints constrainView:[self descriptionLabel]
                                                                  toWidth:227.0f],
                                             
                                             [PFConstraints leftAlignView:[self descriptionLabel]
                                                      relativeToSuperView:[self imageView]
                                                     withDistanceFromEdge:62.0f],
                                             
                                             [PFConstraints positionView:[self descriptionLabel]
                                                               belowView:[self datesLabel]
                                                              withMargin:0.0f],
                                             ]];
    }
    
    return self;
}

@end
