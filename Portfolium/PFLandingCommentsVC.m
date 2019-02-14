//
//  PFLandingCommentsVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFLandingCommentsVC.h"
#import "PFLandingProfileVC.h"
#import "PFLandingNavigationController.h"
#import "PFJoinVC.h"

@interface PFLandingCommentsVC ()

@end

@implementation PFLandingCommentsVC

- (void)pushUserProfile:(NSNumber *)userId; {
    
    [[self rootNavigationController] pushViewController:[PFLandingProfileVC _new:userId]
                                               animated:YES
                                                   shim:self];
}

- (void)submitCommentButtonAction; {
    
    [[self rootNavigationController] pushViewController:[PFJoinVC _new] animated:YES];
}

- (PFLandingNavigationController *)rootNavigationController; {
    
    return (PFLandingNavigationController *)[self navigationController];
}

@end