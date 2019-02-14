//
//  PFCommentField.m
//  Portfolium
//
//  Created by John Eisberg on 9/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFCommentField.h"

@implementation PFCommentField

- (CGRect)textRectForBounds:(CGRect)bounds; {
    
    return CGRectInset(bounds, 10, 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds; {
    
    return CGRectInset(bounds, 10, 10);
}

@end
