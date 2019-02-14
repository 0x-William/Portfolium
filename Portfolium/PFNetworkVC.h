//
//  PFNetworkVC.h
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFRootViewController.h"
#import "PFPagedDatasourceDelegate.h"
#import "PFNetworkViewItemDelegate.h"
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "PFShimmedViewController.h"

@class ABPeoplePickerNavigationControllerDelegate;

@interface PFNetworkVC : UIViewController<PFRootViewController,
                                          UICollectionViewDataSource,
                                          UICollectionViewDelegate,
                                          PFPagedDataSourceDelegate,
                                          PFNetworkViewItemDelegate,
                                          MFMessageComposeViewControllerDelegate,
                                          PFShimmedViewController>

@property(nonatomic, readwrite) UICollectionView *collectionView;

+ (PFNetworkVC *)_new;

@end
