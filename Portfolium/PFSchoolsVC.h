//
//  PFSchoolsVC.h
//  Portfolium
//
//  Created by John Eisberg on 7/30/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFIndexedListVC.h"

@class PFOBEducationVC;

@interface PFSchoolsVC : PFIndexedListVC<UISearchBarDelegate>

+ (PFSchoolsVC *)_new:(NSString *)whoAmI delegate:(PFOBEducationVC *)delegate;

@end
