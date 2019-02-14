//
//  PFSettingsSwitchViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 8/27/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFSettingsSwitchViewCell.h"
#import "PFColor.h"
#import "PFConstraints.h"
#import "PFImage.h"
#import "PFFont.h"

@interface PFSettingsSwitchViewCell ();

@end

@implementation PFSettingsSwitchViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFSettingsSwitchViewCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setFont:[PFFont fontOfLargeSize]];
        [label setTextColor:[PFColor darkGrayColor]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self contentView] addSubview:label];
        [self setLabel:label];
        
        UISwitch *swtch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [swtch setTranslatesAutoresizingMaskIntoConstraints:NO];
        [swtch setOnTintColor:[PFColor blueColor]];
        [swtch setOn:YES];
        [swtch setAlpha:0.0f];
        [[self contentView] addSubview:swtch];
        [self setSwtch:swtch];
        
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
                                             
                                             [PFConstraints constrainView:[self swtch]
                                                                 toHeight:50.0f],
                                             
                                             [PFConstraints constrainView:[self swtch]
                                                                  toWidth:50.0f],
                                             
                                             [PFConstraints rightAlignView:[self swtch]
                                                       relativeToSuperView:[self contentView]
                                                      withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints topAlignView:[self swtch]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:6.0f],
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
                             frame.origin.x = 10.0f;
                             [self label].frame = frame;
                         }
                         completion:^(BOOL finished){
                             
                             [UIView animateWithDuration:0.4f
                                                   delay:0.0f
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  
                                                  [[self swtch] setAlpha:1.0f];
                                              }
                                              completion:^(BOOL finished){
                                              }];
                         }];
    }
}

@end