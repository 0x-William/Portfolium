//
//  PFMenuItems.h
//  Portfolium
//
//  Created by John Eisberg on 6/21/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFMenuVC;

@interface PFMenuItemsVC : UIViewController<UICollectionViewDelegate,
                                            UICollectionViewDataSource>

@property (nonatomic, weak) PFMenuVC *delegate;

+ (PFMenuItemsVC *)menuItemsVCWithDelegate:(PFMenuVC *)delegate;

@end
