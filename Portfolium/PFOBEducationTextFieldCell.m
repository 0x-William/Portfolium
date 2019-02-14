//
//  PFOBEducationTextFieldCell.m
//  Portfolium
//
//  Created by John Eisberg on 7/31/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFOBEducationTextFieldCell.h"
#import "PFColor.h"
#import "PFConstraints.h"
#import "PFImage.h"
#import "PFFont.h"

@interface PFOBEducationTextFieldCell ()

@property(nonatomic, strong) UIImageView *chevron;

@end

@implementation PFOBEducationTextFieldCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFOBEducationTextFieldCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
        [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
        [textField setFont:[PFFont fontOfLargeSize]];
        [textField setTextColor:[PFColor darkGrayColor]];
        [[self contentView] addSubview:textField];
        [self setTextField:textField];
        
        UIImageView *chevron = [[UIImageView alloc] initWithFrame:CGRectZero];
        [chevron setTranslatesAutoresizingMaskIntoConstraints:NO];
        [chevron setImage:[PFImage chevron]];
        [chevron setAlpha:0.0f];
        [[self contentView] addSubview:chevron];
        [self setChevron:chevron];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self textField]
                                                                 toHeight:40.0f],
                                             
                                             [PFConstraints constrainView:[self textField]
                                                                  toWidth:260.0f],
                                             
                                             [PFConstraints leftAlignView:[self textField]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints topAlignView:[self textField]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:2.0f],
                                             
                                             [PFConstraints constrainView:[self chevron]
                                                                 toHeight:39.0f/2],
                                             
                                             [PFConstraints constrainView:[self chevron]
                                                                  toWidth:39.0f/2],
                                             
                                             [PFConstraints rightAlignView:[self chevron]
                                                       relativeToSuperView:[self contentView]
                                                      withDistanceFromEdge:20.0f],
                                             
                                             [PFConstraints topAlignView:[self chevron]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:12.0f],
                                             ]];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated; {
    
    [super setSelected:selected animated:animated];
}

- (void)setTextFieldText:(NSString *)text animated:(BOOL)animated; {
    
    [[self textField] setText:text];
    
    if(animated) {
    
        CGRect frame = [self textField].frame;
        frame.origin.x = -200.0f;
        frame.origin.y = frame.origin.y + 24.0f;
        [self textField].frame = frame;
        
        [UIView animateWithDuration:0.4f
                              delay:0.5f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             CGRect frame = [self textField].frame;
                             frame.origin.x = 10.0f;
                             [self textField].frame = frame;
                         }
                         completion:^(BOOL finished){
                             
                             [UIView animateWithDuration:0.4f
                                                   delay:0.0f
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  
                                                  [[self chevron] setAlpha:1.0f];
                                              }
                                              completion:^(BOOL finished){
                                              }];
                         }];
    }
}

@end
