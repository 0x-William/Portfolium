//
//  UIColor+PFEntensions.h
//  Portfolium
//
//  Created by John Eisberg on 12/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIColor(PFExtensions)

+ (UIColor *)colorWithHex:(UInt32)col;
+ (UIColor *)colorWithHexString:(NSString *)str;

@end
