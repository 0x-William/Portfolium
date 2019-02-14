//
//  PFEntryContainer.h
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFEntryView.h"

@protocol PFEntryContainer <NSObject>

- (PFEntryView *)containedEntryView;

@end
