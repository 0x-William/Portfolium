//
//  PFNotificationsVC.h
//  Portfolium
//
//  Created by John Eisberg on 8/18/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFPagedDatasourceDelegate.h"
#import "PFShimmedViewController.h"

@interface PFNotificationsVC : UIViewController<UITableViewDataSource,
                                                UITableViewDelegate,
                                                PFPagedDataSourceDelegate,
                                                PFShimmedViewController>
+ (PFNotificationsVC *)_new;

- (void)pushUserProfile:(NSNumber *)userId;

@end
