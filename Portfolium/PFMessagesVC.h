//
//  PFMessagesVC.h
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFRootViewController.h"
#import "SWTableViewCell.h"
#import "PFShimmedViewController.h"

@interface PFMessagesVC : UIViewController<UITableViewDataSource,
                                           UITableViewDelegate,
                                           SWTableViewCellDelegate,
                                           PFShimmedViewController,
                                           UIActionSheetDelegate>
+ (PFMessagesVC *)_new;

- (void)markMessageRead:(NSNumber *)threadId;
- (void)pushUserProfile:(NSNumber *)userId;

@end
