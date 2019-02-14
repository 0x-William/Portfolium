//
//  PFLoginVC.h
//  Portfolium
//
//  Created by John Eisberg on 7/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFLoginVC : UIViewController<UITableViewDelegate,
                                        UITableViewDataSource,
                                        UIGestureRecognizerDelegate,
                                        UITextFieldDelegate>
+ (PFLoginVC *) _new;

@end
