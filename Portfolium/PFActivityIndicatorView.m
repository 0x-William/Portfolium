//
//  PFActivityIndicator.m
//  Portfolium
//
//  Created by John Eisberg on 7/23/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFActivityIndicatorView.h"
#import "PFSize.h"
#import "PFColor.h"

@implementation PFActivityIndicatorView

+ (PFActivityIndicatorView *)windowIndicatorView; {
    
    DSXActivityIndicator *view = [[DSXActivityIndicator alloc] init];
    
    [view setFrame:CGRectMake(([PFSize screenWidth] / 2) - 12.0f,
                              ([PFSize screenHeight] / 2) - 102.0f,
                              30.0f, 30.0f)];
    [view setFadeInOut:NO];
    [view setTintColor:[PFColor blueColor]];
    
    return (PFActivityIndicatorView *)view;
}

+ (PFActivityIndicatorView *)hudIndicatorView; {
    
    DSXActivityIndicator *view = [[DSXActivityIndicator alloc] init];
    [view setFrame:CGRectMake(0, 0, 30.0f, 30.0f)];
    [view setFadeInOut:NO];
    [view setTintColor:[PFColor blueColor]];
    
    return (PFActivityIndicatorView *)view;
}

@end
