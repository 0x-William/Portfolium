//
//  PFSmoothAlertView.h
//  Portfolium
//
//  Created by John Eisberg on 12/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFSmoothAlertView : NSObject

+ (void)forgotPasswordSuccess:(UIViewController *)delegate;

+ (void)changePasswordSuccess:(UIViewController *)delegate;

+ (void)changeEmailSuccess:(UIViewController *)delegate;

@end
