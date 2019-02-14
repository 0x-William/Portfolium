//
//  PFIntro2VC.h
//  Portfolium
//
//  Created by John Eisberg on 12/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFIntro2VC : UIViewController<UICollectionViewDataSource,
                                         UICollectionViewDelegate>
+ (PFIntro2VC *)_new;

+ (BOOL)isViewed;

@end
