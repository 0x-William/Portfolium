//
//  PFAddEntryVC.h
//  Portfolium
//
//  Created by John Eisberg on 11/16/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFAnimatedForm.h"
#import "PFEntry.h"

@class PFCollaborator;
@class PFSystemCategory;
@class PFAddEntryViewItem;
@class ALAsset;

@interface PFAddEntryVC : PFAnimatedForm<UITableViewDataSource,
                                         UITableViewDelegate,
                                         UITextViewDelegate,
                                         UITextFieldDelegate,
                                         UIActionSheetDelegate,
                                         UIImagePickerControllerDelegate,
                                         UINavigationControllerDelegate,
                                         UICollectionViewDataSource,
                                         UICollectionViewDelegate>

+ (PFAddEntryVC *) _new:(PFEntryType)entryType;

- (void)setSubCategory:(PFSystemCategory *)subCategory;

- (void)addCollaborator:(PFCollaborator *)collaborator;

- (void)removeCollaborator:(PFCollaborator *)collaborator;

- (BOOL)isCollaborator:(PFCollaborator *)collaborator;

- (void)addEntryViewItem:(PFAddEntryViewItem *)item
  requestedToggleAtIndex:(NSInteger)index;

@end
