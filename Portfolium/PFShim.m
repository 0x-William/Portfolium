//
//  PFShim.m
//  Portfolium
//
//  Created by John Eisberg on 11/27/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFShim.h"
#import "PFSize.h"
#import "UIViewController+PFExtensions.h"

@implementation PFShim

+ (PFShim *)blackOpaqueFor:(UIViewController *)vc; {
    
    PFShim *shim = [[PFShim alloc] initWithFrame:CGRectMake(0, 0,
                                                            [PFSize screenWidth],
                                                            [vc applicationFrameOffset])];
    [shim setBackgroundColor:[UIColor blackColor]];
    [shim setAlpha:0.8];
    [shim setHidden:[[[vc navigationController] navigationBar] alpha] == 1];
    [[vc view] addSubview:shim];
    
    return shim;
}

+ (PFShim *)hiddenBlackOpaqueFor:(UIViewController *)vc; {
    
    PFShim *shim = [[PFShim alloc] initWithFrame:CGRectMake(0, 0,
                                                            [PFSize screenWidth],
                                                            [vc applicationFrameOffset])];
    [shim setBackgroundColor:[UIColor blackColor]];
    [shim setAlpha:0.8];
    [shim setHidden:YES];
    [[vc view] addSubview:shim];
    
    return shim;
}

@end
