//
//  PFTapGesture.m
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFTapGesture.h"

@implementation PFTapGesture {
}

- (id)init:(UIView *)view
     block:(void (^)(UITapGestureRecognizer *recognizer))gestureRecognizedBlock; {
    
    self = [super init];
    
    if (self) {
        
        _gestureRecognizedBlock = [gestureRecognizedBlock copy];
        _recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
        
        [view addGestureRecognizer:_recognizer];
    }
    
    return self;
}

- (void)Tap:(UITapGestureRecognizer*)recognizer {

    self.gestureRecognizedBlock(recognizer);
}

@end
