//
//  PFModel.h
//  Portfolium
//
//  Created by John Eisberg on 6/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RKObjectMapping;

@protocol PFModel <NSObject>

+ (NSString *)endPoint;

+ (RKObjectMapping *)getMapping;

@end
