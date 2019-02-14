//
//  PFCommentsVC.h
//  Portfolium
//
//  Created by John Eisberg on 8/9/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFPagedDatasourceDelegate.h"
#import "PFShimmedViewController.h"

@class PFLandingCommentsVC;

@interface PFCommentsVC : UIViewController<UITableViewDataSource,
                                           UITableViewDelegate,
                                           PFPagedDataSourceDelegate,
                                           PFShimmedViewController,
                                           UITextViewDelegate>

+ (PFCommentsVC *)_new:(NSNumber *)entryId;
+ (PFLandingCommentsVC *)_landing:(NSNumber *)entryId;

- (void)pushUserProfile:(NSNumber *)userId;

@end
