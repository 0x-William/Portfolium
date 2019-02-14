//
//  PFAddEntryItemView.m
//  Portfolium
//
//  Created by John Eisberg on 12/4/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFAddEntryViewItem.h"
#import "PFFont.h"
#import "PFConstraints.h"
#import "PFButton.h"
#import "PFColor.h"
#import "PFImage.h"
#import "PFAddEntryVC.h"
#import "FAKFontAwesome.h"
#import "UIColor+PFEntensions.h"
#import "PFEntryView.h"

@interface PFAddEntryViewItem ()

@property(nonatomic, strong) UILabel *check;

@end

@implementation PFAddEntryViewItem

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFAddEntryViewItem";
}

- (id)initWithFrame:(CGRect)frame; {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
        [[self imageView] setBackgroundColor:[UIColor whiteColor]];
        [[self imageView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self imageView] setContentMode:UIViewContentModeScaleAspectFit];
        [[self contentView] addSubview:[self imageView]];
        
        FAKFontAwesome *checkIcon = [FAKFontAwesome checkCircleIconWithSize:40];
        [checkIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        
        [self setCheck:[[UILabel alloc] initWithFrame:CGRectZero]];
        [[self check] setBackgroundColor:[UIColor clearColor]];
        [[self check] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self check] setAlpha:0.0f];
        [[self check] setTextAlignment:NSTextAlignmentCenter];
        [[self check] setAttributedText:[checkIcon attributedString]];
        [[self contentView] addSubview:[self check]];
        
        UIButton *tapButton = [PFButton connectButton];
        [tapButton setBackgroundColor:[UIColor clearColor]];
        [tapButton setClipsToBounds:YES];
        [tapButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self contentView] addSubview:tapButton];
        [self setTapButton:tapButton];
        [tapButton addTarget:self
                      action:@selector(toggled:)
            forControlEvents:UIControlEventTouchUpInside];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self imageView]
                                                      toHeightOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints constrainView:[self imageView]
                                                       toWidthOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints leftAlignView:[self imageView]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:0.0f],
                                             
                                             [PFConstraints topAlignView:[self imageView]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:0.0f],
                                             
                                             [PFConstraints constrainView:[self check]
                                                                 toHeight:40.0f],
                                             
                                             [PFConstraints constrainView:[self check]
                                                                  toWidth:40.0f],
                                             
                                             [PFConstraints horizontallyCenterView:[self check]
                                                                       inSuperview:[self contentView]],
                                             
                                             [PFConstraints verticallyCenterView:[self check]
                                                                     inSuperview:[self contentView]],
                                             
                                             [PFConstraints constrainView:[self tapButton]
                                                      toHeightOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints constrainView:[self tapButton]
                                                       toWidthOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints leftAlignView:[self tapButton]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:0.0f],
                                             
                                             [PFConstraints topAlignView:[self tapButton]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:0.0f],
                                             ]];
    }
    
    return self;
}

- (void)pop:(void(^)(void))callback; {
    
    [UIView animateWithDuration:0.3/1.5
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.contentView.transform = CGAffineTransformScale
                         (CGAffineTransformIdentity, 0.95, 0.95);
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
                         
                         self.contentView.transform = CGAffineTransformScale(
                           CGAffineTransformIdentity, 1.0, 1.0);
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
                         
                         self.contentView.transform = CGAffineTransformIdentity;
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
        
        [[self contentView] insertSubview:blueView
                             belowSubview:[self check]];
        
        [UIView animateWithDuration:0.2f animations:^{
            
            [blueView setAlpha:0.4];
        
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.6f animations:^{
    
                [[self check] setAlpha:1];
            }];
        }];
        
    } else {
        
        UIView *blueView = [[self contentView] viewWithTag:1];
        
        [UIView animateWithDuration:0.2
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             [blueView setAlpha:0.0];
                             [[self check] setAlpha:0];
                         }
                         completion:^(BOOL finished){
                            
                             [blueView removeFromSuperview];
                         }];
    }
}

- (void)push:(UIButton *)button; {
}

- (void)toggled:(UIButton *)button; {
    
    if(![self isSelected]) {
     
        [[self delegate] addEntryViewItem:self
                   requestedToggleAtIndex:[self index]];
    }
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
    
    /*[[self imageView] setBackgroundColor:
        [UIColor colorWithHexString:[PFEntryView palateForView]]];*/
    
    [[self imageView] setBackgroundColor:[UIColor blackColor]];
}

- (void)prepareForReuse; {
    
    [super prepareForReuse];
    
    [[self tapButton] setUserInteractionEnabled:YES];
}

@end
