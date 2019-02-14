//
//  PFProgressHud.m
//  Portfolium
//
//  Created by John Eisberg on 12/3/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFProgressHud.h"
#import "MBProgressHUD.h"
#import "PFActivityIndicatorView.h"

static const CGFloat yOffset = -58.0f;

@implementation PFProgressHud

+ (MBProgressHUD *)showForView:(UIView *)view; {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    PFActivityIndicatorView *spinner = [PFActivityIndicatorView hudIndicatorView];
    [spinner startAnimating];
    
    [hud setMode:MBProgressHUDModeCustomView];
    [hud setCustomView:spinner];
    
    [hud setYOffset:yOffset];
    [hud setRemoveFromSuperViewOnHide:YES];
    
    return hud;
}

+ (void)hideForView:(UIView *)view; {
    
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
