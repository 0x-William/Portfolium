//
//  UILabel+PFExtensions.m
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "TTTAttributedLabel+PFExtensions.h"
#import "PFFont.h"
#import "PFMVVModel.h"
#import "PFColor.h"

@implementation TTTAttributedLabel (PFExtentions)

- (void)setText:(NSString *)text enbolden:(NSString *)string; {
    
    [self setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^
     NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
         
         NSRange boldRange = [[mutableAttributedString string] rangeOfString:string];
         UIFont *boldFont = [PFFont boldFontOfMediumSize];
         
         CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldFont.fontName,
                                               boldFont.pointSize, NULL);
         if (font) {
             
             [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                             value:(__bridge id)font range:boldRange];
             CFRelease(font);
         }
         
         return mutableAttributedString;
     }];
}

- (void)link:(NSString *)text to:(NSString *)url; {
    
    NSRange range = [[self text] rangeOfString:text];
    
    NSArray *keys = [[NSArray alloc] initWithObjects:
                     (id)kCTForegroundColorAttributeName,
                     (id)kCTUnderlineStyleAttributeName, nil];
    
    NSArray *objects = [[NSArray alloc] initWithObjects:[PFColor darkGrayColor],
                        [NSNumber numberWithInt:kCTUnderlineStyleNone], nil];
    
    NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    self.linkAttributes = linkAttributes;
    self.activeLinkAttributes = nil;
    
    [self addLinkToURL:[NSURL URLWithString:url] withRange:range];
}

- (void)add:(PFProfile *)profile; {
    
    NSString *name = [[PFMVVModel shared] generateName:profile];
    
    NSRange range = [[self text] rangeOfString:name];
    
    NSArray *keys = [[NSArray alloc] initWithObjects:
                     (id)kCTForegroundColorAttributeName,
                     (id)kCTUnderlineStyleAttributeName, nil];
    
    NSArray *objects = [[NSArray alloc] initWithObjects:[PFColor darkerGrayColor],
                        [NSNumber numberWithInt:kCTUnderlineStyleNone], nil];
    
    NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    self.linkAttributes = linkAttributes;
    self.activeLinkAttributes = nil;
    
    [self addLinkToURL:[NSURL URLWithString:
                        [NSString stringWithFormat:@"%@:%@", @"user",
                         [profile userId]]] withRange:range];
}

- (void)setDate:(NSDate *)date; {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [self setText:[dateFormatter stringFromDate:date]];
}

@end
