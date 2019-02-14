//
//  PFChangePasswordVC.h
//  Portfolium
//
//  Created by John Eisberg on 8/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFChangePasswordVC : UIViewController<UITableViewDelegate,
                                                 UITableViewDataSource,
                                                 UITextFieldDelegate>
+ (PFChangePasswordVC *)_new;

@end
