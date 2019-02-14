//
//  PFActivityIndicator.h
//  Portfolium
//
//  Created by John Eisberg on 7/23/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSXActivityIndicator.h"

@interface PFActivityIndicatorView : DSXActivityIndicator

+ (PFActivityIndicatorView *)windowIndicatorView;

+ (PFActivityIndicatorView *)hudIndicatorView;

@end
