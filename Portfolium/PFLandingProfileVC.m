//
//  PFLandingProfileVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFLandingProfileVC.h"
#import "PFLandingVC.h"
#import "PFLandingProfileTypeVC.h"
#import "PFLandingCommentsVC.h"
#import "UIControl+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFContentView.h"
#import "PFActivityIndicatorView.h"

@interface PFLandingProfileVC ()

@end

@implementation PFLandingProfileVC

+ (PFLandingProfileVC *)_new:(NSNumber *)userId; {
    
    PFLandingProfileVC *vc = [[PFLandingProfileVC alloc] initWithNibName:nil
                                                                  bundle:nil
                                                                  userId:(NSNumber *)userId];
    [vc setUserId:userId]; return vc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
               userId:(NSNumber *)userId; {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setEntriesVC:[PFProfileTypeVC _landingEntries:self userId:userId]];
        [self setAboutVC:[PFProfileTypeVC _landingAbout:self userId:userId]];
        [self setConnectionsVC:[PFProfileTypeVC _landingConnections:self userId:userId]];
        
        [[self entriesVC] view];
        [[self aboutVC] view];
        [[self connectionsVC] view];
    }
    
    return self;
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [[self connectButton] bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [[self connectButton] bk_addEventHandler:^(id sender) {
        
        [[PFLandingVC shared] pushJoinVC];
        
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)doConnectButton:(UIButton *)button; {
    
    [[PFLandingVC shared] pushJoinVC];
}

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

@end
