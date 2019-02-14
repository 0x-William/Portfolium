//
//  PFImageScaleMetaData.m
//  Portfolium
//
//  Created by John Eisberg on 6/23/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFImageScaleMetaData.h"

@implementation PFImageScaleMetaData

+ (CGPoint)transformPoint:(CGPoint)point
         fromOriginalSize:(CGSize)originalSize
                   toSize:(CGSize)toSize; {
    
    CGFloat xRatio =  toSize.width / originalSize.width;
    CGFloat yRatio = toSize.height / originalSize.height;
    
    return CGPointMake(point.x * xRatio, point.y * yRatio);
}

@end