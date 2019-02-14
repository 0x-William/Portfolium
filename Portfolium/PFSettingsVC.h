//
//  PFSettingsVC.h
//  Portfolium
//
//  Created by John Eisberg on 8/26/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFAnimatedForm.h"

@class PFUzer;

@interface PFSettingsVC : PFAnimatedForm<UITableViewDataSource, UITableViewDelegate>

+ (PFSettingsVC *)_new:(PFUzer *)user;

@end
