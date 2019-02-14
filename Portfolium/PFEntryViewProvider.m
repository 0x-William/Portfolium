//
//  PFEntryViewProvider.m
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFEntryViewProvider.h"
#import "PFEntryViewItem.h"
#import "PFColor.h"
#import "PFPagedDatasource.h"
#import "UIImageView+PFImageLoader.h"
#import "PFMVVModel.h"
#import "PFDetailVC.h"
#import "PFEntryContainer.h"
#import "PFSize.h"

@implementation PFEntryViewProvider

+ (PFEntryViewProvider *) shared; {
    
    static dispatch_once_t once;
    static PFEntryViewProvider *shared;
    dispatch_once(&once, ^{
        
        shared = [[PFEntryViewProvider alloc] init];
        
        [shared setEntryForItemAtIndexPathBlock:^(id<PFEntryContainer> item,
                                                  NSIndexPath *indexPath,
                                                  PFPagedDataSource *dataSource,
                                                  id<PFEntryViewDelegate> delegate) {
            
            PFEntry *entry = [dataSource itemAtIndex:[indexPath row]];
            
            [[item containedEntryView] prepareForReuse];
            
            [[item containedEntryView] setEntryDelegate:delegate];
            [[item containedEntryView] setUserId:[entry userId]];
            [[item containedEntryView] setIndex:[indexPath row]];
            [[item containedEntryView] setEntryId:[entry entryId]];
            [[item containedEntryView] setLikeCount:[entry likes]];
            [[item containedEntryView] setCommentCount:[entry commentCount]];
            [[item containedEntryView] setViewCount:[entry views]];
            [[item containedEntryView] setName:[[PFMVVModel shared] generateName:[entry profile]]];
            
            PFFilename *filename = [[PFFilename alloc] init];
            [filename setDynamic:[[PFMVVModel shared] generateAvatarUrl:[entry profile]]];
            
            NSString *url = [filename croppedToSize:[PFEntryView preferredAvatarSize]];
            
            [[[item containedEntryView] avatarView] setImageWithUrl:url
                                                postProcessingBlock:nil
                                                      progressBlock:nil
                                                   placeholderImage:nil
                                                             fadeIn:YES];
            
            PFMedia *media = [[entry media] objectAtIndex:0];
            NSString *entryImageUrl = [[media filename] croppedToSize:
                                       CGSizeMake([PFEntryView preferredImageCrop].width,
                                                  [PFEntryView preferredImageCrop].height)];
            
            [[[item containedEntryView] imageView] setAlpha:0.0f];
            
            [[[item containedEntryView] imageView] setImageWithUrl:entryImageUrl
                                               postProcessingBlock:nil
                                                     progressBlock:nil
                                                  placeholderImage:nil
                                                               tag:[indexPath row]
                                                          callback:^(UIImage *image, NSInteger tag) {
                                                              [UIView animateWithDuration:0.4 animations:^{
                                                                  [[[item containedEntryView] imageView] setAlpha:1.0f];
                                                              }];
                                                          }];
            
            [[[item containedEntryView] titleLabel] setText:[entry title]];
            [[[item containedEntryView] userLabel] setText:[[PFMVVModel shared] generateName:[entry profile]]];
            
            [[[item containedEntryView] starViewLabel] setText:
             [NSString stringWithFormat:@"%@", [entry likes]]];
            [[[item containedEntryView] bubbleViewLabel] setText:
             [NSString stringWithFormat:@"%lu", [[entry commentCount] longValue]]];
            [[[item containedEntryView] eyeViewLabel] setText:
             [NSString stringWithFormat:@"%@", [entry views]]];
            
            [[[item containedEntryView] captionViewLabel] setText:[entry caption]];
            [[item containedEntryView] setComments:[entry comments]];
            
            [[[item containedEntryView] likeButton] setSelected:NO];
            [[[item containedEntryView] likeButton] setUserInteractionEnabled:YES];
            
            if([[entry liked] integerValue] > 0) {
                
                [[[item containedEntryView] likeButton] setSelected:YES];
                [[[item containedEntryView] likeButton] setUserInteractionEnabled:NO];
            }
        }];
        
        [shared setSizeForItemAtIndexPathBlock:^(NSIndexPath *indexPath,
                                                 PFPagedDataSource *dataSource) {
            
            PFEntry *entry = [[dataSource data] objectAtIndex:[indexPath row]];
            
            CGFloat height = [PFEntryView boundingRectWithSize:CGSizeZero
                                                         title:[entry title]
                                                       caption:[entry caption]
                                                      comments:[entry comments]].height;
            
            return CGSizeMake([PFSize screenWidth], height);
        }];
    });
    
    return shared;
}

@end