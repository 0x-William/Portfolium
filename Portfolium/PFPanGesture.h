//
//  PFPanGesture.h
//  Portfolium
//
//  Created by John Eisberg on 7/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

@interface PFPanGesture : NSObject

- (id)init:(UIView *)view
     block:(void (^)(UIPanGestureRecognizer *recognizer))gestureRecognizedBlock;

@property (nonatomic, readonly) UIPanGestureRecognizer *recognizer;
@property (nonatomic, copy) void (^gestureRecognizedBlock)(UIPanGestureRecognizer *recognizer);

@end
