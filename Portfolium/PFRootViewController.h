//
//  PFRootViewController.h
//  Portfolium
//
//  Created by John Eisberg on 6/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    PFViewControllerLaunching,
    PFViewControllerLoading,
    PFViewControllerReady,
    PFViewControllerEmpty,
    PFViewControllerDirty
    
}   PFViewControllerState;

@protocol PFRootViewController <NSObject>

@property(nonatomic, readonly) PFViewControllerState state;

@end