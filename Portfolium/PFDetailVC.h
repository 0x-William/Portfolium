//
//  PFDetailVC.h
//  Portfolium
//
//  Created by John Eisberg on 8/9/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFEntryViewDelegate.h"
#import "TTTAttributedLabel.h"
#import "PFShimmedViewController.h"
#import "PFNetworkViewItemDelegate.h"

@class PFSystemCategory;

@interface PFDetailVC : UIViewController<UITableViewDataSource,
                                         UITableViewDelegate,
                                         TTTAttributedLabelDelegate,
                                         PFShimmedViewController,
                                         UICollectionViewDataSource,
                                         UICollectionViewDelegate,
                                         PFNetworkViewItemDelegate>

@property(nonatomic, strong) NSNumber *entryId;
@property(nonatomic, strong) PFEntry *entry;
@property(nonatomic, weak) id<PFEntryViewDelegate> delegate;
@property(nonatomic, strong) NSNumber *likeCount;
@property(nonatomic, strong) UIView *shim;
@property(nonatomic, weak) UIButton *statusButton;
@property(nonatomic, strong) PFSystemCategory *category;
@property(nonatomic, strong) NSMutableDictionary *images;

+ (PFDetailVC *)_new:(NSNumber *)entryId
            delegate:(id<PFEntryViewDelegate>)delegate;

+ (PFDetailVC *)_upload:(NSNumber *)entryId
               delegate:(id<PFEntryViewDelegate>)delegate;

- (void)pushUserProfile:(NSNumber *)userId;

@end
