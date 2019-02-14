//
//  PFEntryLandingView.m
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFEntryLandingView.h"
#import "PFLandingVC.h"

@implementation PFEntryLandingView

- (void)commentButtonAction:(UIButton *)button; {
    
    [[PFLandingVC shared] pushJoinVC];
}

- (void)likeButtonAction:(UIButton *)button; {
    
    [[PFLandingVC shared] pushJoinVC];
}

@end