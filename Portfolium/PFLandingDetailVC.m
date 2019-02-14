//
//  PFLandingDetailVC.m
//  Portfolium
//
//  Created by John Eisberg on 11/13/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFLandingDetailVC.h"
#import "PFLandingProfileVC.h"
#import "PFJoinVC.h"
#import "TTTAttributedLabel.h"
#import "PFLandingTagsVC.h"
#import "UIControl+BlocksKit.h"
#import "UIView+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFDetailsSocialViewCell.h"
#import "PFLandingNavigationController.h"
#import "PFLandingCategoryFeedVC.h"

static const NSInteger kSocialViewCell = 0;
static const NSInteger kUserViewCell = 1;

@interface PFLandingDetailVC ()

@end

@implementation PFLandingDetailVC

+ (PFDetailVC *)_new:(NSNumber *)entryId
            delegate:(id<PFEntryViewDelegate>)delegate; {
    
    PFLandingDetailVC *vc = [[PFLandingDetailVC alloc] initWithNibName:nil bundle:nil];
    
    [vc setEntryId:entryId];
    [vc setDelegate:delegate];
    
    [vc setImages:[[NSMutableDictionary alloc] init]];
    
    return vc;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if([indexPath row] == kUserViewCell) {
        
        /*[[self statusButton] bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        
        @weakify(self)
        
        [[self statusButton] bk_addEventHandler:^(id sender) {
            
            @strongify(self)
            
            [[self shim] setHidden:NO];
            
            [[self navigationController] pushViewController:[PFJoinVC _new] animated:YES];
            
        } forControlEvents:UIControlEventTouchUpInside];*/
    
    } else if([indexPath row] == kSocialViewCell) {
        
        /*[[(PFDetailsSocialViewCell *)cell categoryLabel] bk_whenTapped:^{
            
            [[self rootNavigationController] pushViewController:(id)[PFLandingCategoryFeedVC _landing:[self category]]
                                                       animated:YES
                                                           shim:self];
        }];*/
    }
    
    return cell;
}

- (void)viewDidLayoutSubviews; {
    
    [super viewDidLayoutSubviews];
    
    [[self statusButton] bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    
    @weakify(self)
    
    [[self statusButton] bk_addEventHandler:^(id sender) {
        
        @strongify(self)
        
        [[self shim] setHidden:NO];
        
        [[self navigationController] pushViewController:[PFJoinVC _new] animated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)pushUserProfile:(NSNumber *)userId; {
    
    [[self shim] setHidden:NO];
    
    [[self navigationController] pushViewController:[PFLandingProfileVC _new:userId]
                                           animated:YES];
}

- (void)commentButtonAction:(UIButton *)button; {
    
    [[self shim] setHidden:NO];
    
    [[self navigationController] pushViewController:[PFJoinVC _new] animated:YES];
}

- (void)likeButtonAction:(NSInteger)index; {
    
    [[self shim] setHidden:NO];
    
    [[self navigationController] pushViewController:[PFJoinVC _new] animated:YES];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url; {

    PFLandingTagsVC *vc = [PFLandingTagsVC _new:[NSString stringWithFormat:@"%@", url]];
    
    [[self navigationController] pushViewController:vc animated:YES];
}

- (void)networkViewItem:(PFNetworkViewItem *)item requestedPushAtIndex:(NSInteger)index; {
    
    [[self shim] setHidden:NO];
    
    PFProfile *profile = [[[self entry] collaborators] objectAtIndex:index];
    
    [[self navigationController] pushViewController:[PFLandingProfileVC _new:[profile userId]]
                                           animated:YES];
}

- (void)networkViewItem:(PFNetworkViewItem *)item requestedToggleAtIndex:(NSInteger)index; {
    
    [[self shim] setHidden:NO];
    
    [[self navigationController] pushViewController:[PFJoinVC _new] animated:YES];
}

- (PFLandingNavigationController *)rootNavigationController; {
    
    return (PFLandingNavigationController *)[self navigationController];
}

@end
