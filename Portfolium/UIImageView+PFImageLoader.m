//
//  UIImageView+PFImageLoader.m
//  Portfolium
//
//  Created by John Eisberg on 6/23/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "AFNetworking.h"
#import "UIImageView+PFImageLoader.h"
#import "PFImageLoader.h"
#import <objc/runtime.h>
#import "UIImage+PFExtensions.h"

static char kPFSuccessBlockObjectKey;
static char kPFImageUrlObjectKey;
static char kPFPostProcessingBlockObjectKey;

@interface BlockerWrapper : NSObject

@property(nonatomic, copy) PFImageLoaderSuccessBlock successBlock;

@end

@implementation BlockerWrapper
@end

@interface UIImageView(_PFImageLoader)

@property(readwrite, nonatomic, strong, setter = pf_setSuccessBlock:) BlockerWrapper *pf_successBlock;
@property(readwrite, nonatomic, strong, setter = pf_setImageUrl:) NSString *pf_imageUrl;
@property(readwrite, nonatomic, strong, setter = pf_setPostProcessingBlock:) PFImageProcess *pf_postProcessingBlock;

@end

@implementation UIImageView(_PFImageLoader)

@dynamic pf_successBlock;
@dynamic pf_imageUrl;
@dynamic pf_postProcessingBlock;

@end

@implementation UIImageView (PFImageLoader)

-(BlockerWrapper *)pf_successBlock; {
    
    return (BlockerWrapper *)objc_getAssociatedObject(self, &kPFSuccessBlockObjectKey);
}

-(void)pf_setSuccessBlock:(BlockerWrapper *)pf_successBlock; {
    
    objc_setAssociatedObject(self, &kPFSuccessBlockObjectKey, pf_successBlock,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)pf_imageUrl; {
    
    return (NSString *)objc_getAssociatedObject(self, &kPFImageUrlObjectKey);
}

-(void)pf_setImageUrl:(NSString *)pf_imageUrl {
    
    objc_setAssociatedObject(self, &kPFImageUrlObjectKey, pf_imageUrl,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(PFImageProcess *)pf_postProcessingBlock; {
    
    return (PFImageProcess *)objc_getAssociatedObject(self, &kPFPostProcessingBlockObjectKey);
}

-(void)pf_setPostProcessingBlock:(PFImageProcess *)pf_postprocessingBlock {
    
    objc_setAssociatedObject(self, &kPFPostProcessingBlockObjectKey, pf_postprocessingBlock,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setImage:(UIImage *)image postProcessingBlock:(PFImageProcess *)postProcessingBlock; {
    
    [self cancelPendingSuccessBlock];
    
    __weak UIImageView *weakSelf = self;
    
    NSString *hash = [image hash];
    
    [self pf_setImageUrl:hash];
    [self pf_setPostProcessingBlock:postProcessingBlock];
    
    BlockerWrapper *wrapper = [[BlockerWrapper alloc] init];
    
    [wrapper setSuccessBlock:^(UIImage *img) {
        [weakSelf setImage:img];
        [weakSelf setNeedsDisplay];
    }];
    
    [self pf_setSuccessBlock:wrapper];
    
    [[PFImageLoader shared] cacheImageWithHash:hash
                                         image:image
                            withPostprocessing:[self pf_postProcessingBlock]
                                       success:[[self pf_successBlock] successBlock]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf setNeedsDisplay];
    });
}

-(void)setImageWithUrl:(NSString *)url
         scaledToWidth:(CGFloat)width
      placeholderImage:(UIImage *)placeholderImage; {
    
    [self setImageWithUrl:url
      postProcessingBlock:[PFImageLoader scaleImageWidthBlock:width]
         placeholderImage:placeholderImage];
}

-(void)setImageWithUrl:(NSString *)url
   postProcessingBlock:(PFImageProcess *)postProcessingBlock
      placeholderImage:(UIImage *)placeholderImage; {
    
    [self cancelPendingSuccessBlock];
    
    [self setImage:placeholderImage];
    
    __weak UIImageView *weakSelf = self;
    
    [self pf_setImageUrl:url];
    [self pf_setPostProcessingBlock:postProcessingBlock];
    
    BlockerWrapper *wrapper = [[BlockerWrapper alloc] init];
    
    [wrapper setSuccessBlock:^(UIImage *img) {
        [weakSelf setImage:img];
        [weakSelf setNeedsDisplay];
    }];
    
    [self pf_setSuccessBlock:wrapper];
    
    [[PFImageLoader shared] cacheImageWithUrl:url
                           withPostprocessing:[self pf_postProcessingBlock]
                                      success:[[self pf_successBlock] successBlock]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf setNeedsDisplay];
    });
}

-(void)setImageWithUrl:(NSString *)url
   postProcessingBlock:(PFImageProcess *)postProcessingBlock
         progressBlock:(PFImageLoaderProgressBlock)progressBlock
      placeholderImage:(UIImage *)placeholderImage
                fadeIn:(BOOL)fadeIn; {
    
    [self cancelPendingSuccessBlock];
    [self setImage:placeholderImage];
    
    if(fadeIn) {
        [self setAlpha:0.0];
    }
    
    __weak UIImageView *weakSelf = self;
    
    [self pf_setImageUrl:url];
    [self pf_setPostProcessingBlock:postProcessingBlock];
    
    BlockerWrapper *wrapper = [[BlockerWrapper alloc] init];
    [wrapper setSuccessBlock:^(UIImage *img) {
        
        [weakSelf setImage:img];
        [weakSelf setNeedsDisplay];
        
        if(fadeIn) {
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.6];
            
            weakSelf.alpha = 1.0;
            
            [UIView commitAnimations];
        }
    }];
    
    [self pf_setSuccessBlock:wrapper];
    
    [[PFImageLoader shared] cacheImageWithUrl:url
                           withPostprocessing:[self pf_postProcessingBlock]
                                     progress:progressBlock
                                      success:[[self pf_successBlock] successBlock]
                                          tag:[weakSelf tag]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf setNeedsDisplay];
    });
}

-(void)setImageWithUrl:(NSString *)url
   postProcessingBlock:(PFImageProcess *)postProcessingBlock
         progressBlock:(PFImageLoaderProgressBlock)progressBlock
      placeholderImage:(UIImage *)placeholderImage
                   tag:(NSInteger)tag
              callback:(void(^)(UIImage *, NSInteger))callback; {
    
    [self cancelPendingSuccessBlock];
    [self setImage:placeholderImage];
    
    __weak UIImageView *weakSelf = self;
    
    [self pf_setImageUrl:url];
    [self pf_setPostProcessingBlock:postProcessingBlock];
    
    BlockerWrapper *wrapper = [[BlockerWrapper alloc] init];
    [wrapper setSuccessBlock:^(UIImage *img) {
        
        [weakSelf setImage:img];
        [weakSelf setNeedsDisplay];
        
        callback(img, tag);
    }];
    
    [self pf_setSuccessBlock:wrapper];
    
    [[PFImageLoader shared] cacheImageWithUrl:url
                           withPostprocessing:[self pf_postProcessingBlock]
                                     progress:progressBlock
                                      success:[[self pf_successBlock] successBlock]
                                          tag:[weakSelf tag]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf setNeedsDisplay];
    });
}

-(void)cancelPendingSuccessBlock; {
    
    if(![self pf_successBlock]) {
        return;
    }
    
    [[PFImageLoader shared] removeSuccessBlock:[[self pf_successBlock] successBlock]
                               forImageWithUrl:[self pf_imageUrl]
                           postProcessingBlock:[self pf_postProcessingBlock]];
    
    [self pf_setSuccessBlock:nil];
    [self pf_setImageUrl:nil];
    [self pf_setPostProcessingBlock:nil];
    
}

@end
