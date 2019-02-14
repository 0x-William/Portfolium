//
//  PFSwipeTransition.h
//  Portfolium
//
//  Created by John Eisberg on 7/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

@interface PFSwipeTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property(nonatomic, assign) BOOL pop;

@end
