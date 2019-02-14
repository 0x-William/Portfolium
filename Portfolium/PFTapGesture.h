//
//  PFTapGesture.h
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFTapGesture : NSObject

- (id)init:(UIView *)view
     block:(void (^)(UITapGestureRecognizer *recognizer))gestureRecognizedBlock;

@property (nonatomic, readonly) UITapGestureRecognizer *recognizer;
@property (nonatomic, copy) void (^gestureRecognizedBlock)(UITapGestureRecognizer *recognizer);

@end
