//
//  PFImageScaleMetaData.h
//  Portfolium
//
//  Created by John Eisberg on 6/23/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFImageScaleMetaData : NSObject

@property(nonatomic, assign) CGSize originalSize;
@property(nonatomic, assign) CGSize scaledSize;

+ (CGPoint)transformPoint:(CGPoint)point
         fromOriginalSize:(CGSize)originalSize
                   toSize:(CGSize)toSize;

@end