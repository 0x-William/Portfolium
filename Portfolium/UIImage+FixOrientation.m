//
//  UIImage+FixOrientation.m
//  Portfolium
//
//  Created by John Eisberg on 1/7/15.
//  Copyright (c) 2015 Portfolium. All rights reserved.
//

#import "UIImage+FixOrientation.h"

static const NSInteger kMaxResolution = 800;

@implementation UIImage (FixOrientation)

- (UIImage *)scaleAndRotateImage; {
    
    CGImageRef imgRef = self.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake( 0, 0, width, height );
    
    if ( width > kMaxResolution || height > kMaxResolution ) {
        
        CGFloat ratio = width/height;
        
        if (ratio > 1) {
            
            bounds.size.width  = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        
        } else {
            
            bounds.size.height = kMaxResolution;
            bounds.size.width  = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake( CGImageGetWidth(imgRef), CGImageGetHeight(imgRef) );
    UIImageOrientation orient = self.imageOrientation;
    CGFloat boundHeight;
    
    switch(orient) {
            
        case UIImageOrientationUp:
            transform = CGAffineTransformIdentity;
            break;
        
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default: break;
    }
    
    UIGraphicsBeginImageContext( bounds.size );
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ( orient == UIImageOrientationRight || orient == UIImageOrientationLeft ) {
        
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    
    } else {
        
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM( context, transform );
    
    CGContextDrawImage( UIGraphicsGetCurrentContext(), CGRectMake( 0, 0, width, height ), imgRef );
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

@end
