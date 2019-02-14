//
//  PFImageLoader.h
//  Portfolium
//
//  Created by John Eisberg on 6/23/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFImageRequestOperation;

typedef UIImage* (^PFImageLoaderPostprocessBlock)(UIImage *img);

typedef void (^PFImageLoaderSuccessBlock)(UIImage *img);

typedef void (^PFImageLoaderProgressBlock)(NSInteger tag,
                                           NSUInteger bytesRead,
                                           long long totalBytesRead,
                                           long long totalBytesExpectedToRead);

typedef void (^PFImageFilterSuccessBlock)(UIImage *img);

@interface PFImageProcess : NSObject

@property(nonatomic, copy) PFImageLoaderPostprocessBlock blk;
@property(nonatomic, strong) NSString *cacheKey;

@end

@interface PFImageLoader : NSObject<NSCacheDelegate>

+ (PFImageLoader *)shared;

+ (PFImageProcess *)scaleAndRotateImageBlock;

+ (PFImageProcess *)scaleImageWidthBlock:(CGFloat)width;

+ (PFImageProcess *)rescaleToSizeBlock:(CGSize)size;

+ (PFImageProcess *)centerAndCropToSize:(CGSize)size;

+ (PFImageProcess *)centerAndCropToCircle:(CGSize)size
                                   radius:(NSInteger)radius;

+ (PFImageProcess *)identityProcess;

- (void)cacheImageWithUrl:(NSString *)url
       withPostprocessing:(PFImageProcess *)postProcessingBlock
                  success:(PFImageLoaderSuccessBlock)success;

- (void)cacheImageWithUrl:(NSString *)url
       withPostprocessing:(PFImageProcess *)postProcessingBlock
                 progress:(PFImageLoaderProgressBlock)progressBlock
                  success:(PFImageLoaderSuccessBlock)success
                      tag:(NSInteger)tag;

- (void)cacheImageWithHash:(NSString *)hash
                     image:(UIImage *)image
        withPostprocessing:(PFImageProcess *)postProcessingBlock
                   success:(PFImageLoaderSuccessBlock)success;

- (void)cacheImageWithUrl:(NSString *)url
       withPostprocessing:(PFImageProcess *)postProcessingBlock;

- (void)removeSuccessBlock:(PFImageLoaderSuccessBlock)success
           forImageWithUrl:(NSString *)url
       postProcessingBlock:(PFImageProcess *)postProcessingBlock;

- (UIImage *)getImageFromCache:(NSString *)url
           withProcessingBlock:(PFImageProcess *)processingBlock;

@end