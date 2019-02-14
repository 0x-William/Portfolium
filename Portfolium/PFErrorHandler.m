//
//  PFErrorHandler.m
//  Portfolium
//
//  Created by John Eisberg on 9/5/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFErrorHandler.h"
#import "PFErrorView.h"
#import "UIViewController+PFExtensions.h"

@implementation PFErrorHandler

+ (PFErrorHandler *)shared; {
    
    static dispatch_once_t once;
    static PFErrorHandler *shared;
    
    dispatch_once(&once, ^{
        
        shared = [[PFErrorHandler alloc] init];
    });
    
    return shared;
}

- (void)showInErrorBar:(NSError *)error
              delegate:(id<PFErrorViewDelegate>)delegate
                inView:(UIView *)view
                header:(PFHeaderState)headerState; {
    
    if([error localizedDescription]) {
    
        PFErrorView *errorView = [[PFErrorView alloc] initWithErrors:@[[error localizedDescription]]
                                                            delegate:delegate];
        if(headerState == PFHeaderOpaque) {
            
            CGRect frame = errorView.frame;
            frame.origin.y = 64;
            errorView.frame = frame;
        }
        
        [view addSubview:errorView];
        if([PFErrorView hidden]) {
            [errorView show:YES];
        }
    }
}

@end
