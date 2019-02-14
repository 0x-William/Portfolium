//
//  PFFont.m
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFFont.h"

static NSString *kFontName = @"HelveticaNeue";
static NSString *kThinName = @"HelveticaNeue-Thin";

@implementation PFFont

// regular

+ (UIFont *)fontOfSmallestSize; {
    
    return [UIFont fontWithName:kThinName size:9];
}

+ (UIFont *)fontOfSmallerSize; {
    
    return [UIFont fontWithName:kThinName size:11];
}

+ (UIFont *)fontOfSmallSize; {
    
    return [UIFont fontWithName:kThinName size:12];
}

+ (UIFont *)fontOfMediumSize; {

    return [UIFont fontWithName:kThinName size:14];
}

+ (UIFont *)fontOfCategorySize {
    return [UIFont fontWithName:kThinName size:16];
}

+ (UIFont *)fontOfLargeSize; {

    return [UIFont fontWithName:kThinName size:18];
}

// system

+ (UIFont *)systemFontOfSmallerSize; {
    
    return [UIFont fontWithName:kFontName size:11];
}

+ (UIFont *)systemFontOfSmallSize; {
    
    return [UIFont fontWithName:kFontName size:12];
}

+ (UIFont *)systemFontOfMediumSize; {
    
    return [UIFont fontWithName:kFontName size:14];
}

+ (UIFont *)systemFontOfLargeSize; {
    
    return [UIFont fontWithName:kFontName size:18];
}

// bold

+ (UIFont *)boldFontOfSmallestSize; {
    
    return [UIFont boldSystemFontOfSize:9];
}

+ (UIFont *)boldFontOfSmallerSize; {
    
    return [UIFont boldSystemFontOfSize:11];
}

+ (UIFont *)boldFontOfSmallSize; {
    
    return [UIFont boldSystemFontOfSize:12];
}

+ (UIFont *)boldFontOfMediumSize; {
    
    return [UIFont boldSystemFontOfSize:14];
}

+ (UIFont *)boldFontOfLargeSize; {
    
    return [UIFont boldSystemFontOfSize:18];
}

+ (UIFont *)boldFontOfExtraLargeSize; {
    
    return [UIFont boldSystemFontOfSize:21];
}

@end
