//
//  PFDetailsDescriptionViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 8/10/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFDetailsDescriptionViewCell.h"
#import "PFFont.h"
#import "PFConstraints.h"
#import "PFColor.h"
#import "PFSize.h"

@interface PFDetailsDescriptionViewCell ()

@property(nonatomic, strong) UILabel *captionLabel;

@end

@implementation PFDetailsDescriptionViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFDetailsDescriptionViewCell";
}

+ (CGFloat)heightForRowAtCaption:(NSString *)caption; {
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[PFFont fontOfMediumSize]
                                                                 forKey:NSFontAttributeName];
    
    CGSize size = [caption boundingRectWithSize:CGSizeMake([PFSize screenWidth] - 30, MAXFLOAT)
                                        options:NSStringDrawingTruncatesLastVisibleLine|
                                                NSStringDrawingUsesLineFragmentOrigin
                                     attributes:stringAttributes context:nil].size;
    return size.height + 10.0f;
}

+ (PFDetailsDescriptionViewCell *)build:(UITableView *)tableView; {
    
    PFDetailsDescriptionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                          [PFDetailsDescriptionViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = [[PFDetailsDescriptionViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:[PFDetailsDescriptionViewCell preferredReuseIdentifier]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UILabel *captionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [captionLabel setBackgroundColor:[UIColor whiteColor]];
        [captionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [captionLabel setNumberOfLines:0];
        [captionLabel setFont:[PFFont fontOfMediumSize]];
        [captionLabel setTextColor:[PFColor grayColor]];
        [[self contentView] addSubview:captionLabel];
        [self setCaptionLabel:captionLabel];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self captionLabel]
                                                                  toWidth:[PFSize screenWidth] - 30],
                                             
                                             [PFConstraints leftAlignView:[self captionLabel]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints topAlignView:[self captionLabel]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:5.0f]
                                             ]];
    }
    
    return self;
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
    
    [[self captionLabel] setText:[self caption]];
}

@end
