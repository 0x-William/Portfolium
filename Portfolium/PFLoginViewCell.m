//
//  PFLoginViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 7/27/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFLoginViewCell.h"
#import "PFConstraints.h"
#import "PFFont.h"
#import "PFColor.h"
#import "FAKFontAwesome.h"

@implementation PFLoginViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFLoginViewCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UILabel *iconLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [iconLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [iconLabel setBackgroundColor:[UIColor whiteColor]];
        [iconLabel setTextAlignment:NSTextAlignmentCenter];
        [iconLabel setAlpha:0.0f];
        [[self contentView] addSubview:iconLabel];
        [self setIconLabel:iconLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
        [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
        [textField setFont:[PFFont fontOfLargeSize]];
        [textField setTextColor:[PFColor textFieldTextColor]];
        [[self contentView] addSubview:textField];
        [self setTextField:textField];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self iconLabel]
                                                                 toHeight:24.0f],
                                             
                                             [PFConstraints constrainView:[self iconLabel]
                                                                  toWidth:24.0f],
                                             
                                             [PFConstraints leftAlignView:[self iconLabel]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:12.0f],
                                             
                                             [PFConstraints topAlignView:[self iconLabel]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:9.0f],
                                             
                                             [PFConstraints constrainView:[self textField]
                                                                 toHeight:40.0f],
                                             
                                             [PFConstraints constrainView:[self textField]
                                                                  toWidth:240.0f],
                                             
                                             [PFConstraints leftAlignView:[self textField]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:50.0f],
                                             
                                             [PFConstraints topAlignView:[self textField]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:2.0f],
                                             ]];
    }
    
    return self;
}

- (void)setIcon:(FAKFontAwesome *)icon; {
    
    [[self iconLabel] setAttributedText:[icon attributedString]];
    
    [UIView animateWithDuration:2.0f animations:^{
        [[self iconLabel] setAlpha:1.0f];
    }];
}

- (void)setTextFieldPlaceholder:(NSString *)placeholder; {
    
    if ([[self textField] respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        UIColor *color = [PFColor placeholderTextColor];
        NSDictionary *attributes = @{ NSForegroundColorAttributeName: color };
        
        [self textField].attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                                 attributes:attributes];
    }
    
    CGRect frame = [self textField].frame;
    frame.origin.x = 520.0f;
    frame.origin.y = frame.origin.y + 24.0f;
    [self textField].frame = frame;
    
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect frame = [self textField].frame;
                         frame.origin.x = 50.0f;
                         [self textField].frame = frame;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated; {
    
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
    
    CGRectIntegral([self textField].frame);
}

@end
