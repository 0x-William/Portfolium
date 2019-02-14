//
//  PFJoinEmailViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFJoinEmailViewCell.h"
#import "PFConstraints.h"
#import "PFColor.h"
#import "PFFont.h"
#import "UIView+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFSize.h"

@implementation PFJoinEmailViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFJoinEmailViewCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
        [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
        [textField setBackgroundColor:[UIColor whiteColor]];
        [textField setFont:[PFFont fontOfLargeSize]];
        [textField setTextColor:[PFColor textFieldTextColor]];
        [[self contentView] addSubview:textField];
        [self setTextField:textField];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [label setBackgroundColor:[UIColor whiteColor]];
        [label setTextColor:[PFColor placeholderTextColor]];
        [label setTextAlignment:NSTextAlignmentRight];
        [[self contentView] addSubview:label];
        [self setLabel:label];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self textField]
                                                                 toHeight:40.0f],
                                             
                                             [PFConstraints constrainView:[self textField]
                                                                  toWidth:170.0f],
                                             
                                             [PFConstraints leftAlignView:[self textField]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints topAlignView:[self textField]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:3.0f],
                                             
                                             [PFConstraints constrainView:[self label]
                                                                 toHeight:40.0f],
                                             
                                             [PFConstraints constrainView:[self label]
                                                                  toWidth:120.0f],
                                             
                                             [PFConstraints leftAlignView:[self label]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:[PFSize joinEmailViewCellText]],
                                             
                                             [PFConstraints topAlignView:[self label]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:2.0f],
                                             ]];
        [self makeLabelClickable];
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
        frame.origin.x = 520.0f;
        frame.origin.y = frame.origin.y + 24.0f;
        [self label].frame = frame;
        
        [UIView animateWithDuration:0.4f
                              delay:0.7f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             CGRect frame = [self label].frame;
                             frame.origin.x = 170.0f;
                             [self label].frame = frame;
                         }
                         completion:^(BOOL finished){
                         }];
    }
}

- (void)makeLabelClickable; {
    
    @weakify(self)
    
    [self bk_whenTapped:^{
        
        @strongify(self)
        
        [[self textField] becomeFirstResponder];
    }];
}

@end
