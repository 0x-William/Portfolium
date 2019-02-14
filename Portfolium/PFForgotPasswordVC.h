//
//  PFForgotPasswordVC.h
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFForgotPasswordVC : UIViewController<UITableViewDelegate,
                                                 UITableViewDataSource,
                                                 UITextFieldDelegate>
+ (PFForgotPasswordVC *)_new;

@end
