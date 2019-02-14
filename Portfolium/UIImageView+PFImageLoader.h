//
//  UIImageView+PFImageLoader.h
//  Portfolium
//
//  Created by John Eisberg on 6/23/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFImageLoader.h"

@interface UIImageView (PFImageImageLoader)

-(void)setImage:(UIImage *)url postProcessingBlock:(PFImageProcess *)postProcessingBlock;

-(void)setImageWithUrl:(NSString *)url
         scaledToWidth:(CGFloat)width
      placeholderImage:(UIImage *)placeholderImage;

-(void)setImageWithUrl:(NSString *)url
   postProcessingBlock:(PFImageProcess *)postProcessingBlock
      placeholderImage:(UIImage *)placeholderImage;

-(void)setImageWithUrl:(NSString *)url
   postProcessingBlock:(PFImageProcess *)postProcessingBlock
         progressBlock:(PFImageLoaderProgressBlock)progressBlock
      placeholderImage:(UIImage *)placeholderImage
                fadeIn:(BOOL)fadeIn;

-(void)setImageWithUrl:(NSString *)url
   postProcessingBlock:(PFImageProcess *)postProcessingBlock
         progressBlock:(PFImageLoaderProgressBlock)progressBlock
      placeholderImage:(UIImage *)placeholderImage
                   tag:(NSInteger)tag
              callback:(void(^)(UIImage *, NSInteger))callback;

-(void)cancelPendingSuccessBlock;

@end
