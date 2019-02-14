//
//  PFFont.h
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFFont : NSObject

// regular

+ (UIFont *)fontOfSmallestSize;

+ (UIFont *)fontOfSmallerSize;

+ (UIFont *)fontOfSmallSize;

+ (UIFont *)fontOfMediumSize;

+ (UIFont *)fontOfCategorySize;

+ (UIFont *)fontOfLargeSize;

// system

+ (UIFont *)systemFontOfSmallerSize;

+ (UIFont *)systemFontOfSmallSize;

+ (UIFont *)systemFontOfMediumSize;

+ (UIFont *)systemFontOfLargeSize;

// bold

+ (UIFont *)boldFontOfSmallestSize;

+ (UIFont *)boldFontOfSmallerSize;

+ (UIFont *)boldFontOfSmallSize;

+ (UIFont *)boldFontOfMediumSize;

+ (UIFont *)boldFontOfLargeSize;

+ (UIFont *)boldFontOfExtraLargeSize;

@end
