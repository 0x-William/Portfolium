//
//  UIImage+PFImageScaleMetaData.h
//  Portfolium
//
//  Created by John Eisberg on 6/23/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFImageScaleMetaData;

@interface UIImage (PFImageScaleMetaData)

@property (nonatomic, strong, setter=pf_setImageScaleMetaData:) PFImageScaleMetaData *pf_imageScaleMetaData;

@end