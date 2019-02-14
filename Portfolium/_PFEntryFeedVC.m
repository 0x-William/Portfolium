//
//  _PFEntryFeed.m
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "_PFEntryFeedVC.h"
#import "NSNotificationCenter+MainThread.h"
#import "PFEntryViewItem.h"
#import "PFApi.h"
#import "PFEntryContainer.h"
#import "PFProfileVC.h"
#import "PFCommentsVC.h"
#import "NSString+PFExtensions.h"
#import "NSURL+PFExtensions.h"
#import "PFErrorHandler.h"
#import "PFHomeVC.h"
#import "UITabBarController+PFExtensions.h"
#import "PFDetailVC.h"
#import "PFFooterBufferView.h"
#import "PFColor.h"
#import "ATConnect.h"
#import "PFGoogleAnalytics.h"
#import "PFSize.h"

static NSString *kApptentiveLikedHandle = @"entry_liked";

@interface _PFEntryFeedVC ()

@property(nonatomic, assign) BOOL barIsUp;

@end

@implementation _PFEntryFeedVC

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setBarIsUp:YES];
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton setBackgroundColor:[UIColor blackColor]];
    [dismissButton setFrame:CGRectMake(0, 0, [PFSize screenWidth], 0)];
    [dismissButton setHidden:YES];
    [dismissButton setAlpha:0.0f];
    [[self view] addSubview:dismissButton];
    [self setDismissButton:dismissButton];
    
    [dismissButton addTarget:self
                      action:@selector(dismissButtonAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(commentPosted:)
                                                 name:kCommentPosted
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated; {
    
    [super viewWillDisappear:animated];
    
    [[[PFHomeVC shared] tabBarController] setMainTabBarHidden:NO animated:YES];
    [self setBarIsUp:YES];
}

- (void)commentButtonAction:(CGRect)converted
                      index:(NSInteger)index
              keyboardFrame:(CGRect)keyboardFrame
                 viewHeight:(CGFloat)viewHeight; {
    
    CGFloat difference = [PFSize screenHeight] - keyboardFrame.size.height;
    
    CGFloat currentOffsetY = [self scrollView].contentOffset.y;
    CGFloat offset = currentOffsetY + converted.origin.y - difference + viewHeight;
    CGPoint contentOffset = CGPointMake(0.0f, offset);
    
    CGRect frame = [self dismissButton].frame;
    frame.size.height = [PFSize screenHeight] - (keyboardFrame.size.height + viewHeight);
    [self dismissButton].frame = frame;
    
    [[self dismissButton] setHidden:NO];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [[self scrollView] setContentOffset:contentOffset animated:NO];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [[self dismissButton] setAlpha:0.5];
            [[self scrollView] setScrollEnabled:NO];
        }];
    }];
    
    [self setCurrentOffsetY:currentOffsetY];
    [self setCurrentIndex:index];
}

- (void)dismissButtonAction:(UIButton *)button; {
    
    if(![[self dismissButton] isHidden]) {
    
        CGPoint contentOffset = CGPointMake(0.0f, [self currentOffsetY]);
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [[self dismissButton] setAlpha:0.0];
            [[self scrollView] setScrollEnabled:YES];
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 animations:^{
                
                [[self scrollView] setContentOffset:contentOffset animated:NO];
                
            } completion:^(BOOL finished) {
                
                [[self dismissButton] setHidden:YES];
            }];
        }];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self currentIndex] inSection:0];
        id<PFEntryContainer> cell;
        
        if([[self scrollView] isKindOfClass:[UITableView class]]) {
            
            cell = (id)[(UITableView *)[self scrollView]
                        cellForRowAtIndexPath:indexPath];
        } else {
            
            cell = (id)[(UICollectionView *)[self scrollView]
                        cellForItemAtIndexPath:indexPath];
        }
        
        PFEntryView *view = [cell containedEntryView];
        [view resignFirstResponder];
        
        [[view commentTextView] resignFirstResponder];
        [[view commentView] setHidden:YES];
        
        [view resetCommentView];
    }
}

- (void)commentTextViewDidGrow; {
    
    CGRect frame = [self dismissButton].frame;
    frame.size.height = frame.size.height - 14;
    [self dismissButton].frame = frame;
}

- (void)commentTextViewDidShrink; {
    
    CGRect frame = [self dismissButton].frame;
    frame.size.height = frame.size.height + 14;
    [self dismissButton].frame = frame;
}

- (void)submitCommentButtonAction:(NSInteger)index
                          comment:(NSString *)comment; {
    
    PFEntry *entry = [[[self dataSource] data] objectAtIndex:index];
    
    [[PFApi shared] postComment:[entry entryId]
                        comment:comment
                        success:^(PFComment *obj) {
                            
                            NSDictionary *userInfo = @{ @"entryId" : [entry entryId],
                                                        @"comment" : obj };
                            
                            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kCommentPosted
                                                                                            object:self
                                                                                          userInfo:userInfo];
                            [[PFGoogleAnalytics shared] commentedOnEntryFromFeed];
                        } failure:^NSError *(NSError *error) {
                            
                            [[PFErrorHandler shared] showInErrorBar:error
                                                           delegate:nil
                                                             inView:[self view]
                                                             header:PFHeaderShowing];
                            return error;
                        }];
}

- (void)likeButtonAction:(NSInteger)index
                  sender:(UIButton *)sender; {
    
    PFEntry *entry = [[[self dataSource] data] objectAtIndex:index];
    
    [sender setSelected:YES];
    
    [[PFApi shared] postLike:[entry entryId]
                     success:^(PFComment *comment) {
                         
                         NSDictionary *userInfo = @{ @"entryId" : [entry entryId] };
                         
                         [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kEntryLiked
                                                                                         object:self
                                                                                       userInfo:userInfo];
                         [[PFGoogleAnalytics shared] likedEntryFromFeed];
                         
                     } failure:^NSError *(NSError *error) {
                         
                         [sender setSelected:NO];
                         
                         [[PFErrorHandler shared] showInErrorBar:error
                                                        delegate:nil
                                                          inView:[self view]
                                                          header:PFHeaderShowing];
                         return error;
                     }];
}

- (void)commentPosted:(NSNotification *)notification; {
    
    PFComment *comment = [[notification userInfo] objectForKey:@"comment"]; PFEntry *entry;
    
    for(int i = 0; i < [[[self dataSource] data] count]; i++) {
        
        entry = [[[self dataSource] data] objectAtIndex:i];
        
        if([entry isKindOfClass:[PFEntry class]]) {
        
            if([[entry entryId] integerValue] == [[comment entryId] integerValue]) {
            
                NSMutableArray *comments = [NSMutableArray arrayWithArray:[entry comments]];
                [comments insertObject:comment atIndex:0];
            
                if([comments count] > 2) {
                    [comments removeObjectAtIndex:2];
                }
            
                [entry setComments:comments];
            
                [self dismissButtonAction:nil];
            
                if([[self scrollView] isKindOfClass:[UITableView class]]) {
                
                    [(UITableView *)[self scrollView] beginUpdates];
                    [(UITableView *)[self scrollView] endUpdates];
                
                } else {
                
                    [(UICollectionView *)[self scrollView] reloadData];
                }
            }
        }
    }
}

- (void)entryViewed:(NSNumber *)entryId; {
    
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kEntryViewed
                                                                    object:self
                                                                  userInfo:@{ @"entryId" : entryId }];
}

- (void)pushUserProfile:(NSNumber *)userId; {
    
    [[self navigationController] pushViewController:[PFProfileVC _new:userId]
                                           animated:YES];
}

- (void)pushComments:(NSNumber *)entryId; {
    
    [[self navigationController] pushViewController:[PFCommentsVC _new:entryId]
                                           animated:YES];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url; {
    
    if([url isProfileURL]) {
        
        [self pushUserProfile:[url getUserId]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate; {
    
    if (!decelerate) {
        [self scrollingDidFinish];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; {
    
    [self scrollingDidFinish];
}

- (void)scrollingDidFinish {
    
    if(![self barIsUp]) {
        
        [[[PFHomeVC shared] tabBarController] setMainTabBarHidden:NO animated:YES];
        [self setBarIsUp:YES];
    }
}

- (void)pushEntryDetail:(NSNumber *)entryId index:(NSInteger)index; {
    
    PFEntry *entry = [[[self dataSource] data] objectAtIndex:index];
    
    [[self navigationController] pushViewController:[PFDetailVC _new:[entry entryId] delegate:self]
                                           animated:YES];
}

- (void)refreshAnimated:(BOOL)animated; {
    
    [[self dataSource] refresh];
    
    [[self scrollView] setContentOffset:CGPointMake(0, -self.scrollView.contentInset.top)
                               animated:animated];
}

- (void)entryLikedAtIndex:(NSInteger)index; {
    
    PFEntry *entry = [[[self dataSource] data] objectAtIndex:index];
    NSInteger likes = [[entry likes] integerValue];
    
    likes = likes + 1;
    
    [entry setLikes:[NSNumber numberWithLong:likes]];
    [entry setLiked:[NSNumber numberWithLong:1]];

    [[ATConnect sharedConnection] engage:kApptentiveLikedHandle
                      fromViewController:self];
}

- (void)commentAtIndex:(NSInteger)index; {
    
    PFEntry *entry = [[[self dataSource] data] objectAtIndex:index];
    NSInteger commentCount = [[entry commentCount] integerValue];
    
    commentCount = commentCount + 1;
    
    [entry setCommentCount:[NSNumber numberWithLong:commentCount]];
}

- (void)entryViewedAtIndex:(NSInteger)index; {
    
    PFEntry *entry = [[[self dataSource] data] objectAtIndex:index];
    NSInteger views = [[entry views] integerValue];
    
    views = views + 1;
    
    [entry setViews:[NSNumber numberWithLong:views]];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        PFFooterBufferView *buffer = [collectionView dequeueReusableSupplementaryViewOfKind:
                                      UICollectionElementKindSectionFooter withReuseIdentifier:
                                      [PFFooterBufferView preferredReuseIdentifier]
                                                                               forIndexPath:indexPath];
        
        [buffer setBackgroundColor:[PFColor lighterGrayColor]];
        
        return buffer;
    }
    
    return nil;
}

- (void)dealloc; {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
