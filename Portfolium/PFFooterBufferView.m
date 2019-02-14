//
//  PFFooterBufferView.m
//  Portfolium
//
//  Created by John Eisberg on 11/22/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFFooterBufferView.h"
#import "PFSize.h"

@implementation PFFooterBufferView

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFFooterBufferView";   
}

+ (CGSize)size; {
    
    return CGSizeMake([PFSize screenWidth], 48);
}

@end
