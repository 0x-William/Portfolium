//
//  PFUsersVC.h
//  Portfolium
//
//  Created by John Eisberg on 8/12/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFShimmedViewController.h"
#import "PFNetworkViewItemDelegate.h"

@interface PFUsersVC : UIViewController<UICollectionViewDataSource,
                                        UICollectionViewDelegate,
                                        PFShimmedViewController,
                                        PFNetworkViewItemDelegate>

+ (PFUsersVC *)_new:(NSNumber *)threadId;

@end
