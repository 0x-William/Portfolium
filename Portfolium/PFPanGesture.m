//
//  PFPanGesture.m
//  Portfolium
//
//  Created by John Eisberg on 7/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFPanGesture.h"

@implementation PFPanGesture {
    
    BOOL _leftToRightTransition;
}

- (id)init:(UIView *)view
     block:(void (^)(UIPanGestureRecognizer *recognizer))gestureRecognizedBlock; {
    
    self = [super init];
    
    if (self) {
        
        _gestureRecognizedBlock = [gestureRecognizedBlock copy];
        _recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        
        [view addGestureRecognizer:_recognizer];
    }
    
    return self;
}

- (void)pan:(UIPanGestureRecognizer*)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.gestureRecognizedBlock(recognizer);
    }
}

@end
