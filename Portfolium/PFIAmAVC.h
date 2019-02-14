//
//  PFIAmAVC.h
//  Portfolium
//
//  Created by John Eisberg on 7/30/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFOBEducationVC;

@interface PFIAmAVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

+ (PFIAmAVC *)_new:(PFOBEducationVC *)delegate;

@end
