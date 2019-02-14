//
//  PFProfileTypeVC.h
//  Portfolium
//
//  Created by John Eisberg on 8/7/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFPagedDatasourceDelegate.h"
#import "PFNetworkViewItemDelegate.h"
#import "TTTAttributedLabel.h"
#import "PFProfileFeedVC.h"

@class PFProfileVC;
@class PFProfileHeaderView;
@class PFProfileSectionHeaderView;
@class PFLandingProfileVC;
@class PFLandingProfileTypeVC;

@interface PFProfileTypeVC : PFProfileFeedVC<UICollectionViewDataSource,
                                             UICollectionViewDelegate,
                                             PFNetworkViewItemDelegate>

@property(nonatomic, assign) NSInteger slug;
@property(nonatomic, assign) CGFloat currentNavigationBarAlpha;

+ (PFProfileTypeVC *)_entries:(PFProfileVC *)delegate
                       userId:(NSNumber *)userId;

+ (PFProfileTypeVC *)_about:(PFProfileVC *)delegate
                     userId:(NSNumber *)userId;

+ (PFProfileTypeVC *)_connections:(PFProfileVC *)delegate
                           userId:(NSNumber *)userId;

+ (PFLandingProfileTypeVC *)_landingEntries:(PFLandingProfileVC *)delegate
                       userId:(NSNumber *)userId;

+ (PFLandingProfileTypeVC *)_landingAbout:(PFLandingProfileVC *)delegate
                     userId:(NSNumber *)userId;

+ (PFLandingProfileTypeVC *)_landingConnections:(PFLandingProfileVC *)delegate
                           userId:(NSNumber *)userId;

@end
