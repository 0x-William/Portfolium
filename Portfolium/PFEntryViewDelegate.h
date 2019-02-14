//
//  PFEntryViewDelegate.h
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFPagedDataSource.h"

@protocol PFEntryViewDelegate <NSObject>

- (void)pushUserProfile:(NSNumber *)userId;
- (void)pushComments:(NSNumber *)entryId;

- (void)pushEntryDetail:(NSNumber *)entryId
                  index:(NSInteger)index;

- (void)commentButtonAction:(CGRect)converted
                      index:(NSInteger)index
              keyboardFrame:(CGRect)keyboardFrame
                 viewHeight:(CGFloat)viewHeight;

- (void)submitCommentButtonAction:(NSInteger)index
                          comment:(NSString *)comment;

- (void)likeButtonAction:(NSInteger)index
                  sender:(UIButton *)sender;

- (void)commentTextViewDidGrow;
- (void)commentTextViewDidShrink;

- (void)entryViewed:(NSNumber *)entryId;

- (void)entryLikedAtIndex:(NSInteger)index;
- (void)commentAtIndex:(NSInteger)index;
- (void)entryViewedAtIndex:(NSInteger)index;

@end