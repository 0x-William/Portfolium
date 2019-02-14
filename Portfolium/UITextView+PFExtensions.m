//
//  UITextView+PFExtensions.m
//  Portfolium
//
//  Created by John Eisberg on 10/5/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "UITextView+PFExtensions.h"

@implementation UITextView (ASExtensions)

- (void)disableQuickTypeBar:(BOOL)disable; {
    
    self.autocorrectionType = disable ? UITextAutocorrectionTypeNo :
                                        UITextAutocorrectionTypeDefault;
    if ([self isFirstResponder]) {
        
        [self resignFirstResponder];
        [self becomeFirstResponder];
    }
}

@end
