//
//  PFErrorViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 9/5/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFErrorViewCell.h"
#import "PFConstraints.h"
#import "TTTAttributedLabel.h"
#import "PFFont.h"
#import "PFImage.h"

@interface PFErrorViewCell ()

@property(nonatomic, strong) UILabel *errorLabel;

@end

@implementation PFErrorViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFErrorViewCell";
}

+ (CGFloat)heightForErrorLabel:(NSString *)error; {
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[PFFont fontOfMediumSize]
                                                                 forKey:NSFontAttributeName];
    
    CGSize size = [error boundingRectWithSize:CGSizeMake(247.0f, MAXFLOAT)
                                      options:NSStringDrawingTruncatesLastVisibleLine|
                   NSStringDrawingUsesLineFragmentOrigin
                                   attributes:stringAttributes context:nil].size;
    return size.height;
}

+ (CGFloat)heightForRowAtError:(NSString *)error; {
    
    CGFloat height = [PFErrorViewCell heightForErrorLabel:error];
    
    return height + 28.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *errorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [errorImageView setBackgroundColor:[UIColor clearColor]];
        [errorImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [errorImageView setContentMode:UIViewContentModeScaleAspectFit];
        [errorImageView setUserInteractionEnabled:YES];
        [errorImageView setImage:[PFImage error]];
        [[self contentView] addSubview:errorImageView];
        
        TTTAttributedLabel *errorLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [errorLabel setBackgroundColor:[UIColor clearColor]];
        [errorLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [errorLabel setNumberOfLines:0];
        [errorLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [errorLabel setFont:[PFFont fontOfMediumSize]];
        [errorLabel setTextColor:[UIColor whiteColor]];
        [[self contentView] addSubview:errorLabel];
        [self setErrorLabel:errorLabel];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:errorImageView
                                                                 toHeight:30.0f],
                                             
                                             [PFConstraints constrainView:errorImageView
                                                                  toWidth:30.0f],
                                             
                                             [PFConstraints leftAlignView:errorImageView
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints topAlignView:errorImageView
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:7.0f],
                                             
                                             [PFConstraints constrainView:[self errorLabel]
                                                                  toWidth:247.0f],
                                             
                                             [PFConstraints leftAlignView:[self errorLabel]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:50.0f],
                                             
                                             [PFConstraints topAlignView:[self errorLabel]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:14.0f],
                                             ]];
    }
    
    return self;
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
    
    [[self errorLabel] setText:[self error]];
}

@end
