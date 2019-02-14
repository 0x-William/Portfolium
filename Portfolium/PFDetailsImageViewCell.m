//
//  PFDetailsImageViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 8/9/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFDetailsImageViewCell.h"
#import "PFConstraints.h"

static CGFloat kImageViewHeight = 204.0f;

@implementation PFDetailsImageViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFDetailsImageViewCell";
}

+ (PFDetailsImageViewCell *)build:(UITableView *)tableView; {
    
    PFDetailsImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                    [PFDetailsImageViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = [[PFDetailsImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:[PFDetailsImageViewCell preferredReuseIdentifier]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

+ (CGFloat)getHeight; {
    
    return kImageViewHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageView setBackgroundColor:[UIColor whiteColor]];
        [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self contentView] addSubview:imageView];
        [self setSliderImageView:imageView];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self sliderImageView]
                                                                 toHeight:kImageViewHeight],
                                             
                                             [PFConstraints constrainView:[self sliderImageView]
                                                       toWidthOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints leftAlignView:[self sliderImageView]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:0.0f],
                                             
                                             [PFConstraints topAlignView:[self sliderImageView]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:0.0f],
                                             ]];
    }
    
    return self;
}

@end
