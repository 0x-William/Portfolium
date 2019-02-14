//
//  UIButton+PFExtensions.m
//  Portfolium
//
//  Created by John Eisberg on 12/16/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "UIButton+PFExtensions.h"
#import "PFFontAwesome.h"
#import "PFImage.h"
#import "FAKFontAwesome.h"
#import "NSAttributedString+CCLFormat.h"

static const CGFloat kInset = 8.0f;

@implementation UIButton (PFExtentions)

- (void)toConnectState; {
 
    UIEdgeInsets insets = UIEdgeInsetsMake(kInset, kInset, kInset, kInset);
    UIImage *stretchableImage = [[PFImage like] resizableImageWithCapInsets:insets];
    
    [self setAttributedTitle:[PFFontAwesome connectIcon]
                    forState:UIControlStateNormal];
    
    [self setBackgroundImage:stretchableImage
                    forState:UIControlStateNormal];
    
    [self setUserInteractionEnabled:YES];
}

- (void)toPendingState; {
    
    UIEdgeInsets insets = UIEdgeInsetsMake(kInset, kInset, kInset, kInset);
    UIImage *stretchableImage = [[PFImage liked] resizableImageWithCapInsets:insets];
    
    [self setAttributedTitle:[PFFontAwesome connectIcon]
                    forState:UIControlStateNormal];
    
    [self setBackgroundImage:stretchableImage
                    forState:UIControlStateNormal];
    
    [self setUserInteractionEnabled:NO];
}

- (void)toAcceptState; {
    
    UIEdgeInsets insets = UIEdgeInsetsMake(kInset, kInset, kInset, kInset);
    UIImage *stretchableImage = [[PFImage accept] resizableImageWithCapInsets:insets];

    [self setAttributedTitle:[PFFontAwesome connectedIcon]
                    forState:UIControlStateNormal];
    
    [self setBackgroundImage:stretchableImage
                    forState:UIControlStateNormal];
    
    [self setUserInteractionEnabled:YES];
}

- (void)toConnectedState; {
    
    UIEdgeInsets insets = UIEdgeInsetsMake(kInset, kInset, kInset, kInset);
    UIImage *stretchableImage = [[PFImage connected] resizableImageWithCapInsets:insets];
    
    [self setAttributedTitle:[PFFontAwesome connectedIcon]
                    forState:UIControlStateNormal];
    
    [self setBackgroundImage:stretchableImage
                    forState:UIControlStateNormal];
    
    [self setUserInteractionEnabled:NO];
}

- (void)toLikeStateWithCount : (NSString*)str {

    FAKFontAwesome *starIcon = [FAKFontAwesome heartIconWithSize:14];
    [starIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    NSAttributedString *star = [starIcon attributedString];
    UIFont *font = [UIFont systemFontOfSize:14];
    NSAttributedString *count = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSAttributedString *combined = [NSAttributedString attributedStringWithFormat:@"%@ %@", star, count];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(kInset, kInset, kInset, kInset);
    UIImage *stretchableImage = [[PFImage like] resizableImageWithCapInsets:insets];
    
    [self setAttributedTitle:combined
                    forState:UIControlStateNormal];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 0);
    [self setBackgroundImage:stretchableImage
                    forState:UIControlStateNormal];
    
    [self setUserInteractionEnabled:YES];
}

- (void)toLikedStateWithCount : (NSString*)str {
    
    FAKFontAwesome *starIcon = [FAKFontAwesome heartIconWithSize:14];
    [starIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    NSAttributedString *star = [starIcon attributedString];
    UIFont *font = [UIFont systemFontOfSize:14];
    NSAttributedString *count = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSAttributedString *combined = [NSAttributedString attributedStringWithFormat:@"%@ %@", star, count];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(kInset, kInset, kInset, kInset);
    UIImage *stretchableImage = [[PFImage liked] resizableImageWithCapInsets:insets];
    
    [self setAttributedTitle:combined
                    forState:UIControlStateNormal];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 0);

    [self setBackgroundImage:stretchableImage
                    forState:UIControlStateNormal];
    
    [self setUserInteractionEnabled:NO];
}

@end
