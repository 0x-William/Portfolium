//
//  PFJeweledButton.m
//  Portfolium
//
//  Created by John Eisberg on 12/18/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFJeweledButton.h"
#import "FAKFontAwesome.h"
#import "PFColor.h"
#import "UIView+BlocksKit.h"
#import "UIControl+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"

static const CGFloat kSize = 30.0f;
static const CGFloat kFontSize = 18.0f;

@implementation PFJeweledButton

+ (PFJeweledButton *)_mail:(void (^)(id sender))handler; {
    
    PFJeweledButton *mailButton =  [[PFJeweledButton alloc] initWithFrame:CGRectMake(0, 0, kSize, kSize)];
    [mailButton setBackgroundColor:[UIColor clearColor]];
    
    FAKFontAwesome *mailIcon = [FAKFontAwesome envelopeIconWithSize:kFontSize];
    [mailIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    FAKFontAwesome *selectedMailIcon = [FAKFontAwesome envelopeIconWithSize:kFontSize];
    [selectedMailIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
    
    [mailButton setAttributedTitle:[mailIcon attributedString]
                          forState:UIControlStateNormal];
    [mailButton setAttributedTitle:[selectedMailIcon attributedString]
                          forState:UIControlStateHighlighted];
    [mailButton setAttributedTitle:[selectedMailIcon attributedString]
                          forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [mailButton bk_addEventHandler:handler
                  forControlEvents:UIControlEventTouchUpInside];
    
    PFJewelView *jewel = [[PFJewelView alloc] initWithFrame:CGRectZero];
    [mailButton insertSubview:jewel aboveSubview:[mailButton titleLabel]];
    [mailButton setJewel:jewel];
    [jewel setHidden:YES];
    
    [jewel bk_whenTapped:^{
        handler(mailButton);
    }];
    
    return mailButton;
}

+ (PFJeweledButton *)_bell:(void (^)(id sender))handler; {
    
    PFJeweledButton *bellButton =  [[PFJeweledButton alloc] initWithFrame:CGRectMake(0, 0, kSize, kSize)];
    [bellButton setBackgroundColor:[UIColor clearColor]];
    
    FAKFontAwesome *bellIcon = [FAKFontAwesome bellIconWithSize:kFontSize];
    [bellIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    FAKFontAwesome *selectedBellIcon = [FAKFontAwesome bellIconWithSize:kFontSize];
    [selectedBellIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
    
    [bellButton setAttributedTitle:[bellIcon attributedString]
                          forState:UIControlStateNormal];
    [bellButton setAttributedTitle:[selectedBellIcon attributedString]
                          forState:UIControlStateHighlighted];
    [bellButton setAttributedTitle:[selectedBellIcon attributedString]
                          forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [bellButton bk_addEventHandler:handler
                  forControlEvents:UIControlEventTouchUpInside];
    
    PFJewelView *jewel = [[PFJewelView alloc] initWithFrame:CGRectZero];
    [bellButton insertSubview:jewel aboveSubview:[bellButton titleLabel]];
    [bellButton setJewel:jewel];
    [jewel setHidden:YES];
    
    [jewel bk_whenTapped:^{
        handler(bellButton);
    }];
    
    return bellButton;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
    }
    
    return self;
}

- (void)setCount:(NSNumber *)count; {
    
    if([count integerValue] <= 0) {
        
        [[self jewel] setHidden:YES];
        
    } else {
        
        [[[self jewel] count] setText:[count stringValue]];
        
        [[self jewel] setHidden:NO];
        [[self jewel] pop];
    }
}

@end
