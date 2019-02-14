//
//  PFColor.h
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFColor : NSObject

+ (UIImage *)imageOfColor:(UIColor *)color;

+ (UIColor *)grayColor;

+ (UIColor *)lighterGrayColor;

+ (UIColor *)commentGrayColor;

+ (UIColor *)lightGrayColor;

+ (UIColor *)darkGrayColor;

+ (UIColor *)darkerGrayColor;

+ (UIColor *)darkestGrayColor;

+ (UIColor *)blueColorOpaque;

+ (UIColor *)blackColorOpaque;

+ (UIColor *)blackColorLessOpaque;

+ (UIColor *)blackColorMoreOpaque;

+ (UIColor *)blueColor;

+ (UIColor *)separatorColor;

+ (UIColor *)titleTextColor;

+ (UIColor *)textFieldTextColor;

+ (UIColor *)placeholderTextColor;

+ (UIColor *)redColorOpaque;

+ (UIColor *)blueGray;

+ (NSString *)blueTabBarColor;

+ (NSString *)defaultTabBarColor;

+ (UIColor *)blueHighlight;

+ (UIColor *)introBackgroundColor;

@end
