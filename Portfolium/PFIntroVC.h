//
//  PFOnboardingVC.h
//  Portfolium
//
//  Created by John Eisberg on 7/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFErrorViewDelegate.h"

@interface PFIntroVC : UIViewController
{
    UIPageControl *pageControl;
}

+ (PFIntroVC *)_new:(NSInteger)index;

+ (void)markViewed;
+ (BOOL)isViewed;

@end
