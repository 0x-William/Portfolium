//
//  PFProfileVC.h
//  Portfolium
//
//  Created by John Eisberg on 8/7/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFProfileSectionHeaderDelegate.h"
#import "_PFEntryFeedVC.h"

@class PFProfileTypeVC;
@class PFNetworkViewItem;

@interface PFProfileVC : _PFEntryFeedVC<PFProfileSectionHeaderDelegate>

@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, strong) PFProfileTypeVC *entriesVC;
@property(nonatomic, strong) PFProfileTypeVC *aboutVC;
@property(nonatomic, strong) PFProfileTypeVC *connectionsVC;
@property(nonatomic, strong) UIButton *connectButton;
@property(nonatomic, strong) UIButton *connectButtonForView;

+ (PFProfileVC *)_new:(NSNumber *)userId;

- (CGFloat)currentNavigationBarAlpha;

@end
