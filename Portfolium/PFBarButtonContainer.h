//
//  PFBarButtonContainer.h
//  Portfolium
//
//  Created by John Eisberg on 7/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFBarButtonContainer : NSObject

+ (UIView *)_continue:(void (^)(id sender))handler;

+ (UIView *)done:(void (^)(id sender))handler;

+ (UIView *)save:(void (^)(id sender))handler;

+ (UIView *)add:(void (^)(id sender))handler;

+ (UIView *)accept:(void (^)(id sender))handler;

+ (UIView *)connect:(void (^)(id sender))handler;

+ (UIView *)backButton:(UIViewController *)delegate;

@end
