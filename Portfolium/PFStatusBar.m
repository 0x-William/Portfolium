//
//  PFStatusBar.m
//  Portfolium
//
//  Created by John Eisberg on 8/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFStatusBar.h"
#import "PFApi.h"

@implementation PFStatusBar

+ (void)statusBarWhite; {
    
    Xcode5Code( {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }, {
    });
}

+ (void)statusBarDefault; {
    
    Xcode5Code( {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }, {
    });
}

@end
