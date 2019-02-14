//
//  PFErrorHandler.h
//  Portfolium
//
//  Created by John Eisberg on 9/5/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFErrorViewDelegate.h"

typedef enum {
    
    PFHeaderHiding,
    PFHeaderShowing,
    PFHeaderOpaque
    
}   PFHeaderState;

typedef NSError* (^PFErrorHandlerBlock)(NSError *error);

@interface PFErrorHandler : NSObject

+ (PFErrorHandler *)shared;

- (void)showInErrorBar:(NSError *)error
              delegate:(id<PFErrorViewDelegate>)delegate
                inView:(UIView *)view
                header:(PFHeaderState)headerState;

@end
