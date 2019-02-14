//
//  PFLandingDetailVC.h
//  Portfolium
//
//  Created by John Eisberg on 11/13/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFDetailVC.h"
#import "PFEntryViewDelegate.h"

@interface PFLandingDetailVC : PFDetailVC

+ (PFDetailVC *)_new:(NSNumber *)entryId
            delegate:(id<PFEntryViewDelegate>)delegate;

@end
