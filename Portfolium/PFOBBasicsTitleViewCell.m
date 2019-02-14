//
//  PFOBBasicsTitleViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 7/31/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFOBBasicsTitleViewCell.h"
#import "PFColor.h"
#import "PFConstraints.h"
#import "PFImage.h"
#import "PFFont.h"

@interface PFOBBasicsTitleViewCell ()

@end

@implementation PFOBBasicsTitleViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFOBBasicsTitleViewCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setBackgroundColor:[PFColor lightGrayColor]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setTextColor:[PFColor titleTextColor]];
        [label setFont:[PFFont fontOfMediumSize]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self contentView] addSubview:label];
        [self setLabel:label];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self label]
                                                                 toHeight:40.0f],
                                             
                                             [PFConstraints constrainView:[self label]
                                                                  toWidth:260.0f],
                                             
                                             [PFConstraints leftAlignView:[self label]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints topAlignView:[self label]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:2.0f],
                                             ]];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated; {
    
    [super setSelected:selected animated:animated];
}

@end
