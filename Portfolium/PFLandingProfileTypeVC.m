//
//  PFLandingProfileTypeVC.m
//  Portfolium
//
//  Created by John Eisberg on 10/18/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFLandingProfileTypeVC.h"
#import "PFLandingVC.h"
#import "PFLandingProfileVC.h"
#import "PFLandingDetailVC.h"

@interface PFLandingProfileTypeVC ()

@end

@implementation PFLandingProfileTypeVC

- (void)likeButtonAction:(NSInteger)index
                  sender:(UIButton *)sender; {
    
    [[PFLandingVC shared] pushJoinVC];
}

- (void)networkViewItem:(PFNetworkViewItem *)item
   requestedPushAtIndex:(NSInteger)index; {
    
    PFProfile *profile = [[[self dataSource] data] objectAtIndex:index];
    
    [[(id)[self delegate] navigationController] pushViewController:[PFLandingProfileVC _new:[profile userId]]
                                                          animated:YES];
}

- (void)networkViewItem:(PFNetworkViewItem *)item
 requestedToggleAtIndex:(NSInteger)index; {
    
    [[PFLandingVC shared] pushJoinVC];
}

- (void)pushEntryDetail:(NSNumber *)entryId index:(NSInteger)index; {
    
    PFLandingDetailVC *vc = [PFLandingDetailVC _new:entryId delegate:self];
    
    [[(id)[self delegate] navigationController] pushViewController:vc animated:YES];
}

@end
