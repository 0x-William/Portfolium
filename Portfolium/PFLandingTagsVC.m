//
//  PFLandingTagsVC.m
//  Portfolium
//
//  Created by John Eisberg on 11/24/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFLandingTagsVC.h"
#import "PFApi.h"
#import "PFMagicNumbers.h"
#import "PFContentView.h"
#import "PFColor.h"
#import "PFEntryLandingViewItem.h"
#import "PFFooterBufferView.h"
#import "PFEntryViewProvider.h"
#import "UIImageView+PFImageLoader.h"
#import "PFLandingVC.h"
#import "PFLandingProfileVC.h"
#import "PFCommentsVC.h"
#import "PFLandingDetailVC.h"
#import "UIViewController+PFExtensions.h"
#import "PFLandingNavigationController.h"

@interface PFLandingTagsVC ()

@end

@implementation PFLandingTagsVC

+ (PFLandingTagsVC *)_new:(NSString *)tag; {
    
    PFLandingTagsVC *vc = [[PFLandingTagsVC alloc] initWithNibName:nil bundle:nil];
    [vc setTag:tag];
    
    PFPagedDataSource *dataSource = [PFPagedDataSource dataSourceWithPageSize:kDefaultPageSize
                                                                   dataLoader:^(NSInteger pageNumber,
                                                                                PFApiFeedSuccessBlock successBlock,
                                                                                PFApiErrorHandlerBlock failure) {
                                                                       
                                                                       [[PFApi shared] tagFeed:tag
                                                                                    pageNumber:pageNumber
                                                                                       success:^(NSArray *data) {
                                                                                           successBlock(data);
                                                                                       }
                                                                                       failure:^NSError *(NSError *error) {
                                                                                           return error;
                                                                                       }];
                                                                   }];
    [dataSource setDelegate:vc];
    [vc setDataSource:dataSource];
    
    return vc;
}

- (void)loadView; {
    
    [self setTitle:[NSString stringWithFormat:@"#%@", [self tag]]];
    [self setUpImageBackButton];
    
    PFContentView *view = [[PFContentView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[PFColor lighterGrayColor]];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumInteritemSpacing:0.0f];
    [layout setMinimumLineSpacing:0.0f];
    [layout setSectionInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:layout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView registerClass:[PFEntryLandingViewItem class]
       forCellWithReuseIdentifier:[PFEntryLandingViewItem preferredReuseIdentifier]];
    [collectionView registerClass:[PFFooterBufferView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
              withReuseIdentifier:[PFFooterBufferView preferredReuseIdentifier]];
    [collectionView setBackgroundColor:[PFColor lighterGrayColor]];
    [view setContentView:collectionView];
    [self setCollectionView:collectionView];
    [self setScrollView:collectionView];
    
    [self setView:view];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PFEntryLandingViewItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:
                                    [PFEntryLandingViewItem preferredReuseIdentifier] forIndexPath:indexPath];
    
    [[PFEntryViewProvider shared] entryForItemAtIndexPathBlock]
    (item, indexPath, [self dataSource], self);

    return item;
}

- (void)plusButtonAction; {
    
    [[PFLandingVC shared] pushJoinVC];
}

- (void)pushUserProfile:(NSNumber *)userId; {
    
    [[self rootNavigationController] pushViewController:[PFLandingProfileVC _new:userId]
                                           animated:YES
                                               shim:self];
}

- (void)pushComments:(NSNumber *)entryId; {
    
    [[self navigationController] pushViewController:(id)[PFCommentsVC _landing:entryId]
                                           animated:YES];
}

- (PFLandingNavigationController *)rootNavigationController; {
    
    return (PFLandingNavigationController *)[self navigationController];
}

- (void)pushEntryDetail:(NSNumber *)entryId index:(NSInteger)index; {

    PFLandingDetailVC *vc = [PFLandingDetailVC _new:entryId delegate:self];
    
    [[self navigationController] pushViewController:vc animated:YES];
}

@end
