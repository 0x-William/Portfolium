//
//  PFMessageNewViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 8/11/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFMessagesNewViewCell.h"
#import "PFConstraints.h"

@implementation PFMessagesNewViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFLoginViewCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
        [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self contentView] addSubview:textField];
        [self setTextField:textField];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self textField]
                                                                 toHeight:40.0f],
                                             
                                             [PFConstraints constrainView:[self textField]
                                                                  toWidth:240.0f],
                                             
                                             [PFConstraints leftAlignView:[self textField]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:16.0f],
                                             
                                             [PFConstraints topAlignView:[self textField]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:2.0f],
                                             ]];
    }
    
    return self;
}

- (void)setText:(NSString *)text animated:(BOOL)animated; {
    
    [[self textField] setText:text];
    
    [self animate];
}

- (void)setTextFieldPlaceholder:(NSString *)placeholder; {
    
    [[self textField] setPlaceholder:placeholder];
    
    [self animate];
}

- (void)animate; {
    
    CGRect frame = [self textField].frame;
    frame.origin.x = 520.0f;
    frame.origin.y = frame.origin.y + 24.0f;
    [self textField].frame = frame;
    
    [UIView animateWithDuration:0.4f
                          delay:0.4f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect frame = [self textField].frame;
                         frame.origin.x = 10.0f;
                         [self textField].frame = frame;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated; {
    
    [super setSelected:selected animated:animated];
}

@end
