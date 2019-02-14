//
//  UIImage+PFImageScaleMetaData.m
//  Portfolium
//
//  Created by John Eisberg on 6/23/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "UIImage+PFImageScaleMetaData.h"
#import "PFImageScaleMetaData.h"
#import <objc/runtime.h>

static char kPFImageScaleMetaData;

@implementation UIImage (PFImageScaleMetaData)

@dynamic pf_imageScaleMetaData;

-(PFImageScaleMetaData *)pf_imageScaleMetaData; {
    
    return (PFImageScaleMetaData *) objc_getAssociatedObject(self, &kPFImageScaleMetaData);
}

-(void)pf_setImageScaleMetaData:(PFImageScaleMetaData *)metaData; {
    
    objc_setAssociatedObject(self, &kPFImageScaleMetaData, metaData,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
