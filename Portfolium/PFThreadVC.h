//
//  PFThreadVC.h
//  Portfolium
//
//  Created by John Eisberg on 8/12/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFShimmedViewController.h"

@class PFMessagesVC;

@interface PFThreadVC : UIViewController<UITableViewDataSource,
                                         UITableViewDelegate,
                                         PFShimmedViewController>

+ (PFThreadVC *)_new:(NSNumber *)threadId
             subject:(NSString *)subject
            archived:(BOOL)archived
            delegate:(PFMessagesVC *)delegate;

- (void)pushUserProfile:(NSNumber *)userId;

@end
