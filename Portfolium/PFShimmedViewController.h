//
//  PFShimmedViewController.h
//  Portfolium
//
//  Created by John Eisberg on 10/11/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFShimmedViewController <NSObject>

- (void)showShim;

- (void)hideShim;

- (BOOL)shimmed;

- (void)setShimmed:(BOOL)shimmed;

@end