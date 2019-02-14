//
//  PFProgressHud.h
//  Portfolium
//
//  Created by John Eisberg on 12/3/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBProgressHUD;

@interface PFProgressHud : NSObject

+ (MBProgressHUD *)showForView:(UIView *)view;

+ (void)hideForView:(UIView *)view;

@end
