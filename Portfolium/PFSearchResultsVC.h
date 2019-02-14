//
//  PFSearchResultsVC.h
//  Portfolium
//
//  Created by John Eisberg on 8/19/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "_PFEntryFeedVC.h"
#import "PFShimmedViewController.h"

@interface PFSearchResultsVC : _PFEntryFeedVC<PFShimmedViewController>

+ (PFSearchResultsVC *)_new:(NSString *)q;

- (void)entriesButtonAction:(UIButton *)button;
- (void)peopleButtonAction:(UIButton *)button;

@end
