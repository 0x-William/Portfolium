//
//  PFOBBasicsImageViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 7/31/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFOBBasicsImageViewCell.h"
#import "PFColor.h"
#import "PFConstraints.h"
#import "PFImage.h"
#import "PFFont.h"

@interface PFOBBasicsImageViewCell ()

@property(nonatomic, strong) UIImageView *chevron;

@end

@implementation PFOBBasicsImageViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFOBBasicsImageViewCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectZero];
        [avatar setTranslatesAutoresizingMaskIntoConstraints:NO];
        [avatar setContentMode:UIViewContentModeScaleAspectFill];
        [avatar setBackgroundColor:[UIColor whiteColor]];
        [avatar setClipsToBounds:YES];
        [avatar setAlpha:0.0f];
        [[self contentView] addSubview:avatar];
        [self setAvatar:avatar];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setFont:[PFFont fontOfMediumSize]];
        [label setTextColor:[PFColor blueColor]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self contentView] addSubview:label];
        [self setLabel:label];
        
        UIImageView *chevron = [[UIImageView alloc] initWithFrame:CGRectZero];
        [chevron setTranslatesAutoresizingMaskIntoConstraints:NO];
        [chevron setImage:[PFImage chevron]];
        [chevron setAlpha:0.0f];
        [[self contentView] addSubview:chevron];
        [self setChevron:chevron];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self avatar]
                                                                 toHeight:54.0f],
                                             
                                             [PFConstraints constrainView:[self avatar]
                                                                  toWidth:54.0f],
                                             
                                             [PFConstraints leftAlignView:[self avatar]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints topAlignView:[self avatar]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints constrainView:[self label]
                                                                 toHeight:40.0f],
                                             
                                             [PFConstraints constrainView:[self label]
                                                                  toWidth:260.0f],
                                             
                                             [PFConstraints leftAlignView:[self label]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:70.0f],
                                             
                                             [PFConstraints topAlignView:[self label]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:16.0f],
                                             
                                             [PFConstraints constrainView:[self chevron]
                                                                 toHeight:39.0f/2],
                                             
                                             [PFConstraints constrainView:[self chevron]
                                                                  toWidth:39.0f/2],
                                             
                                             [PFConstraints rightAlignView:[self chevron]
                                                       relativeToSuperView:[self contentView]
                                                      withDistanceFromEdge:20.0f],
                                             
                                             [PFConstraints topAlignView:[self chevron]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:26.0f],
                                             ]];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated; {
    
    [super setSelected:selected animated:animated];
}

- (void)setLabelText:(NSString *)text animated:(BOOL)animated; {
    
    [[self label] setText:text];
    
    if(animated) {
    
        CGRect frame = [self label].frame;
        frame.origin.x = -200.0f;
        frame.origin.y = frame.origin.y + 24.0f;
        [self label].frame = frame;
        
        [UIView animateWithDuration:0.4f
                              delay:0.5f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             CGRect frame = [self label].frame;
                             frame.origin.x = 50.0f;
                             [self label].frame = frame;
                         }
                         completion:^(BOOL finished){
                             
                             [UIView animateWithDuration:0.4f
                                                   delay:0.0f
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  
                                                  [[self chevron] setAlpha:1.0f];
                                                  [[self avatar] setAlpha:1.0f];
                                              }
                                              completion:^(BOOL finished){
                                              }];
                         }];
    }
}

@end
