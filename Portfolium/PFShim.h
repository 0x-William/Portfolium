//
//  PFShim.h
//  Portfolium
//
//  Created by John Eisberg on 11/27/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFShim : UIView

+ (PFShim *)blackOpaqueFor:(UIViewController *)vc;

+ (PFShim *)hiddenBlackOpaqueFor:(UIViewController *)vc;

@end
