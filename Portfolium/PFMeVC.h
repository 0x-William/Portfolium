//
//  PFMeVC.h
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFRootViewController.h"
#import "PFProfileSectionHeaderDelegate.h"
#import "_PFEntryFeedVC.h"

@class PFMeTypeVC;

@interface PFMeVC : _PFEntryFeedVC<PFProfileSectionHeaderDelegate,
                                   PFRootViewController>

@property(nonatomic, weak) PFMeTypeVC *activeVC;
@property(nonatomic, assign) PFViewControllerState state;

+ (PFMeVC *)_new;

- (CGFloat)currentNavigationBarAlpha;

- (void)addEntry:(PFEntry *)entry;

@end
