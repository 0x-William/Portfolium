//
//  PFSmoothAlertView.m
//  Portfolium
//
//  Created by John Eisberg on 12/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFSmoothAlertView.h"
#import "AMSmoothAlertView.h"

@implementation PFSmoothAlertView

+ (void)forgotPasswordSuccess:(UIViewController *)delegate; {
    
    [self doAlert:NSLocalizedString(@"Success!", nil)
             text:NSLocalizedString(@"An email has been sent with reset instructions.", nil)
        alertType:AlertSuccess
         delegate:delegate];
}

+ (void)changePasswordSuccess:(UIViewController *)delegate; {
    
    [self doAlert:NSLocalizedString(@"Success!", nil)
             text:NSLocalizedString(@"Your password has been successfully changed.", nil)
        alertType:AlertSuccess
         delegate:delegate];
}

+ (void)changeEmailSuccess:(UIViewController *)delegate; {
    
    [self doAlert:NSLocalizedString(@"Success!", nil)
             text:NSLocalizedString(@"Your email has been successfully changed.", nil)
        alertType:AlertSuccess
         delegate:delegate];
}

+ (void)doAlert:(NSString *)title
           text:(NSString *)text
      alertType:(AlertType)alertType
       delegate:(UIViewController *)delegate; {
    
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc]
                                initDropAlertWithTitle:title
                                andText:text
                                andCancelButton:NO
                                forAlertType:alertType];
    
    alert.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button) {
        [[delegate navigationController] popViewControllerAnimated:YES];
    };
    
    [alert show];
}

@end
