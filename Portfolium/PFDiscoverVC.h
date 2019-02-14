//
//  PFDiscoverVC.h
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFRootViewController.h"
#import "PFCategoriesVC.h"

@interface PFDiscoverVC : PFCategoriesVC<PFRootViewController, UITextFieldDelegate>

+ (PFDiscoverVC *) _new;

@end
