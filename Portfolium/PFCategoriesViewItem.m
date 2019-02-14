//
//  PFCategoriesViewItem.m
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFCategoriesViewItem.h"
#import "PFConstraints.h"
#import "PFFont.h"
#import "PFColor.h"

@implementation PFCategoriesViewItem

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFCategoriesViewItem";
}

- (id)initWithFrame:(CGRect)frame; {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
        [self setBackgroundView:[self imageView]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [label setNumberOfLines:0];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setFont:[PFFont systemFontOfSmallSize]];
        [label setTextColor:[UIColor whiteColor]];
        [[self contentView] addSubview:label];
        [self setLabel:label];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self label]
                                                                  toWidth:90.0f],
                                             
                                             [PFConstraints leftAlignView:[self label]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:4.0f],
                                             
                                             [PFConstraints bottomAlignView:[self label]
                                                        relativeToSuperView:[self contentView]
                                                       withDistanceFromEdge:4.0f],
                                             ]];
    }
    
    return self;
}

- (void)pop:(void(^)(void))callback; {
    
    [UIView animateWithDuration:0.3/1.5
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
                     }
                     completion:^(BOOL finished){
                         
                         [self bounceInAnimationStopped:callback];
                     }];
}

- (void)bounceInAnimationStopped:(void(^)(void))callback; {
    
    [UIView animateWithDuration:0.3/1.5
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                     }
                     completion:^(BOOL finished){
                         
                         [self bounceOutAnimationStopped:callback];
                     }];
}

- (void)bounceOutAnimationStopped:(void(^)(void))callback; {
    
    [UIView animateWithDuration:0.3/1.5
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished){
                         
                         callback();
                     }];
}

- (void)setSelected:(BOOL)selected; {
    
    if (self.selected == selected) return;
    
    [super setSelected:selected];
    
    if(selected) {
    
        UIView *blueView = [[UIView alloc] initWithFrame:[[self contentView] frame]];
        [blueView setBackgroundColor:[PFColor blueColor]];
        [blueView setAlpha:0.0f];
        [blueView setTag:1];
        [[blueView layer] setCornerRadius:4.0f];
        [[self contentView] insertSubview:blueView belowSubview:[self label]];
        
        [UIView animateWithDuration:0.2f animations:^{
            [blueView setAlpha:0.4];
        }];
    
    } else {
        
        UIView *blueView = [[self contentView] viewWithTag:1];
        
        [UIView animateWithDuration:0.2
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             [blueView setAlpha:0.0];
                         }
                         completion:^(BOOL finished){
                             
                             [blueView removeFromSuperview];
                         }];
    }
}

@end