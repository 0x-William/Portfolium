//
//  PFMenuVC.h
//  Portfolium
//
//  Created by John Eisberg on 6/21/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFMenuItemsVC;

@interface PFMenuVC : UIViewController

@property (nonatomic, strong) PFMenuItemsVC *menuItemsVC;

+ (PFMenuVC *)shared;

@end
