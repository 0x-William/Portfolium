//
//  PFNetworkViewItemDelegate.h
//  Portfolium
//
//  Created by John Eisberg on 8/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFNetworkViewItem;
@class PFProfile;

@protocol PFNetworkViewItemDelegate <NSObject>

- (void)networkViewItem:(PFNetworkViewItem *)item
   requestedPushAtIndex:(NSInteger)index;

- (void)networkViewItem:(PFNetworkViewItem *)item
 requestedToggleAtIndex:(NSInteger)index;

@end