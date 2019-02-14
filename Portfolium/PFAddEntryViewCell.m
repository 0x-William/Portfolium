//
//  PFAddEntryViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 11/16/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFAddEntryViewCell.h"
#import "PFColor.h"
#import "PFConstraints.h"
#import "PFImage.h"
#import "PFFont.h"

@interface PFAddEntryViewCell ();

@end

@implementation PFAddEntryViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFAddEntryViewCell";
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
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self textField]
                                                                 toHeight:40.0f],
                                             
                                             [PFConstraints constrainView:[self textField]
                                                                  toWidth:280.0f],
                                             
                                             [PFConstraints leftAlignView:[self textField]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints topAlignView:[self textField]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:2.0f]
                                             ]];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated; {
    
    [super setSelected:selected animated:animated];
}

- (void)setPlaceholderText:(NSString *)text animated:(BOOL)animated; {
    
    if ([[self textField] respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        UIColor *color = [PFColor placeholderTextColor];
        NSDictionary *attributes = @{ NSForegroundColorAttributeName: color };
        
        [self textField].attributedPlaceholder = [[NSAttributedString alloc] initWithString:text
                                                                                 attributes:attributes];
    }
    
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
                         }];
    }
}

@end
