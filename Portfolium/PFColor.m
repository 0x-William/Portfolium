//
//  PFColor.m
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFColor.h"

@implementation PFColor

+ (UIImage *)imageOfColor:(UIColor *)color; {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIColor *)lighterGrayColor; {
    
    return [UIColor colorWithRed:245.0f/255.0f
                           green:245.0f/255.0f
                            blue:245.0f/255.0f
                           alpha:1.0];
}

+ (UIColor *)commentGrayColor; {
    
    return [UIColor colorWithRed:248.0f/255.0f
                           green:248.0f/255.0f
                            blue:248.0f/255.0f
                           alpha:1.0];
}

+ (UIColor *)lightGrayColor; {
    
    return [UIColor colorWithRed:(234/255.0)
                           green:(234/255.0)
                            blue:(234/255.0)
                           alpha:1];
}

+ (UIColor *)grayColor; {
    
    return [UIColor colorWithRed:159/255.0
                           green:159/255.0
                            blue:159/255.0
                           alpha:1];
}

+ (UIColor *)darkGrayColor; {
    
    return [UIColor colorWithRed:139/255.0
                           green:139/255.0
                            blue:139/255.0
                           alpha:1];
}

+ (UIColor *)darkerGrayColor; {
    
    return [UIColor colorWithRed:79/255.0
                           green:79/255.0
                            blue:79/255.0
                           alpha:1];
}

+ (UIColor *)darkestGrayColor; {
    
    return [UIColor colorWithRed:59/255.0
                           green:59/255.0
                            blue:59/255.0
                           alpha:1];
}

+ (UIColor *)blueColorOpaque; {
    
    return [UIColor colorWithRed:25/255.0
                           green:100/255.0
                            blue:253/255.0
                           alpha:0.9];
}

+ (UIColor *)blackColorOpaque; {
    
    return [UIColor colorWithRed:0/255.0
                           green:0/255.0
                            blue:0/255.0
                           alpha:0.8];
}

+ (UIColor *)blackColorLessOpaque; {
    
    return [UIColor colorWithRed:0/255.0
                           green:0/255.0
                            blue:0/255.0
                           alpha:0.3];
}

+ (UIColor *)blackColorMoreOpaque; {
    
    return [UIColor colorWithRed:0/255.0
                           green:0/255.0
                            blue:0/255.0
                           alpha:0.5];
}

+ (UIColor *)blueColor; {
    
    return [UIColor colorWithRed:25/255.0
                           green:100/255.0
                            blue:253/255.0
                           alpha:1];
}

+ (UIColor *)separatorColor; {
    
    return [UIColor colorWithRed:224/255.0
                           green:224/255.0
                            blue:224/255.0
                           alpha:1];
}

+ (UIColor *)titleTextColor; {
    
    return [PFColor grayColor];
}

+ (UIColor *)textFieldTextColor; {
    
    return [PFColor darkGrayColor];
}

+ (UIColor *)placeholderTextColor; {
    
    return [PFColor grayColor];
}

+ (UIColor *)redColorOpaque; {
    
    return [UIColor colorWithRed:237/255.0
                           green:28/255.0
                            blue:36/255.0
                           alpha:0.8];
}

+ (UIColor *)blueGray; {
    
    return [UIColor colorWithRed:236/255.0
                           green:239/255.0
                            blue:250/255.0
                           alpha:1];
}

+ (NSString *)blueTabBarColor; {
    
    return @"0059bf";
}

+ (NSString *)defaultTabBarColor; {
    
    return @"313131";
}

+ (UIColor *)blueHighlight; {
    
    return [UIColor colorWithRed:0.875
                           green:0.941
                            blue:1
                           alpha:0.5f];
}

+ (UIColor *)introBackgroundColor {
    return [UIColor colorWithRed:28/255.0
                           green:28/255.0
                            blue:29/255.0
                           alpha:1.0f];
}
@end
