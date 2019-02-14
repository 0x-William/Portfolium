//
//  PFSubCategoriesVC.h
//  Portfolium
//
//  Created by John Eisberg on 11/16/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFIndexedListVC.h"

@class PFAddEntryVC;

@interface PFSubCategoriesVC : PFIndexedListVC<UISearchBarDelegate>

+ (PFSubCategoriesVC *)_new:(PFAddEntryVC *)delegate;

@end
