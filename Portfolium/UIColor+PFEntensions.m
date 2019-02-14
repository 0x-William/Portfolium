//
//  UIColor+PFEntensions.m
//  Portfolium
//
//  Created by John Eisberg on 12/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "UIColor+PFEntensions.h"
#import "NSString+PFExtensions.h"

@implementation UIColor(PFExtensions)

+ (UIColor *)colorWithHexString:(NSString *)str {
    
    if(![NSString isNullOrEmpty:str]) {
        
        const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
        long x = strtol(cStr, NULL, 16);
        return [UIColor colorWithHex:(UInt32)x];
    
    } else {
        
        return [UIColor blackColor];
    }
}

+ (UIColor *)colorWithHex:(UInt32)col {
    
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    
    return [UIColor colorWithRed:(float)r/255.0f
                           green:(float)g/255.0f
                            blue:(float)b/255.0f
                           alpha:1];
}

@end