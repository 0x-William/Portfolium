//
//  PFImageLoader.m
//  Portfolium
//
//  Created by John Eisberg on 6/23/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFImageLoader.h"
#import "AFImageRequestOperation.h"
#import <objc/runtime.h>
#import <CoreGraphics/CoreGraphics.h>
#import "PFImageScaleMetaData.h"
#import "UIImage+PFImageScaleMetaData.h"
#import "UIImage+FixOrientation.h"

static const NSUInteger kMaxRetries = 2;
static dispatch_queue_t pf_image_preload_and_scaling_queue;

static dispatch_queue_t image_preload_and_scaling_queue() {
    
    if (pf_image_preload_and_scaling_queue == NULL) {
        pf_image_preload_and_scaling_queue =
        dispatch_queue_create("com.portfolium.networking.image.processing", 0);
    } return pf_image_preload_and_scaling_queue;
}

@interface PFImageLoader()

@property(nonatomic, strong) NSCache *imageCache;
@property(nonatomic, strong) NSMutableSet *inflightKeys;
@property(nonatomic, strong) NSMutableDictionary *keysToSuccessBlocks;

@end

@implementation PFImageProcess
@end

@implementation PFImageLoader

+ (PFImageLoader *)shared {
    
    static PFImageLoader *_sharedImageLoader = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedImageLoader = [[self alloc] init];
    });
    
    return _sharedImageLoader;
}

- (id)init; {
    
    if((self = [super init]) != nil) {
        
        [self setImageCache:[[NSCache alloc] init]];
        [[self imageCache] setDelegate:self];
        [self setInflightKeys:[NSMutableSet set]];
        [self setKeysToSuccessBlocks:[NSMutableDictionary dictionary]];
    }
    return self;
}

- (BOOL)isUrlInflight:(NSString *)url
  withProcessingBlock:(PFImageProcess *)processingBlock;{
    
    BOOL inflight = NO;
    
    @synchronized(self) {
        inflight = [[self inflightKeys] containsObject:
                    [self cacheKeyForImageWithUrl:url
                                  processingBlock:processingBlock]];
    }
    
    return inflight;
}

- (void)makeUrlInflight:(NSString *)url
    withProcessingBlock:(PFImageProcess *)processingBlock; {
    
    @synchronized(self) {
        [[self inflightKeys] addObject:[self cacheKeyForImageWithUrl:url
                                                     processingBlock:processingBlock]];
    }
}

- (void)removeUrlInflight:(NSString *)url
      withProcessingBlock:(PFImageProcess *)processingBlock; {
    
    @synchronized(self) {
        [[self inflightKeys] removeObject:[self cacheKeyForImageWithUrl:url
                                                        processingBlock:processingBlock]];
    }
}

- (NSString *)cacheKeyForImageWithUrl:(NSString *)url
                      processingBlock:(PFImageProcess *)blk; {
    
    NSString *full = [NSString stringWithFormat:@"%@:%@", url, [blk cacheKey]]; return full;
}

+ (PFImageProcess *)scaleAndRotateImageBlock; {
    
    PFImageLoaderPostprocessBlock blk = ^UIImage*(UIImage *inputImage) {
        
        return [inputImage scaleAndRotateImage];
    };
    
    PFImageProcess *process =  [[PFImageProcess alloc] init];
    [process setBlk:blk];
    [process setCacheKey:[NSString stringWithFormat:@"FO"]];
    
    return process;
}

+ (PFImageProcess *)identityProcess; {
    
    PFImageLoaderPostprocessBlock blk = ^UIImage*(UIImage *inputImage) {
        return inputImage;
    };
    
    PFImageProcess *process = [[PFImageProcess alloc] init];
    [process setBlk:blk];
    [process setCacheKey:[NSString stringWithFormat:@"I"]];
    
    return process;
}

+ (PFImageProcess *)scaleImageWidthBlock:(CGFloat)width {
    
    PFImageLoaderPostprocessBlock blk = ^UIImage*(UIImage *inputImage) {
        
        CGFloat origWidth = [inputImage size].width;
        CGFloat origHeight = [inputImage size].height;
        
        CGFloat newWidth = width * [[UIScreen mainScreen] scale];
        
        CGFloat scaleRatio = newWidth / origWidth;
        CGFloat newHeight = scaleRatio * origHeight;
        
        
        CGRect bounds = CGRectMake(0.0f, 0.0f, newWidth, newHeight);
        CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef imageContext = CGBitmapContextCreate(NULL, newWidth, newHeight, 8, newWidth*4, colourSpace, kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little);
        CGContextSetInterpolationQuality(imageContext, kCGInterpolationHigh);
        CGContextDrawImage(imageContext, bounds, [inputImage CGImage]);
        CGImageRef outputImage = CGBitmapContextCreateImage(imageContext);
        
        CGContextRelease(imageContext);
        CGColorSpaceRelease(colourSpace);
        
        UIImage *retMe  = [UIImage imageWithCGImage:outputImage
                                              scale:[[UIScreen mainScreen] scale]
                                        orientation:UIImageOrientationUp];
        
        CGImageRelease(outputImage);
        
        PFImageScaleMetaData *metaData = [[PFImageScaleMetaData alloc] init];
        [metaData setOriginalSize:CGSizeMake(origWidth, origHeight)];
        
        [metaData setScaledSize:CGSizeMake(newWidth / [[UIScreen mainScreen] scale],
                                           newHeight / [[UIScreen mainScreen] scale])];
        
        [retMe pf_setImageScaleMetaData:metaData];
        return retMe;
    };
    
    PFImageProcess *process =  [[PFImageProcess alloc] init];
    [process setBlk:blk];
    [process setCacheKey:[NSString stringWithFormat:@"SW:%f", width]];
    
    return process;
}

+ (PFImageProcess *)rescaleToSizeBlock:(CGSize)size; {
    
    PFImageLoaderPostprocessBlock blk = ^UIImage*(UIImage *inputImage) {
        
        CGAffineTransform scale =  CGAffineTransformMakeScale([[UIScreen mainScreen] scale], [[UIScreen mainScreen] scale]);
        CGSize origSize = CGSizeApplyAffineTransform([inputImage size], scale);
        
        CGSize maxSize = CGSizeApplyAffineTransform(size, scale);
        CGSize newSize = origSize;
        
        
        newSize.width = maxSize.width;
        CGFloat wRatio = newSize.width / origSize.width;
        newSize.height *= wRatio;
        
        if(newSize.height > maxSize.height) {
            
            CGFloat hRatio = maxSize.height / newSize.height;
            newSize.height = maxSize.height;
            newSize.width *= hRatio;
        }
        
        CGRect bounds = CGRectMake(0.0f, 0.0f, newSize.width, newSize.height);
        bounds = CGRectIntegral(bounds);
        
        newSize = bounds.size;
        
        CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef imageContext = CGBitmapContextCreate(NULL, newSize.width, newSize.height, 8, newSize.width*4,
                                                          colourSpace, kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little);
        
        CGContextSetInterpolationQuality(imageContext, kCGInterpolationHigh);
        CGContextDrawImage(imageContext, bounds, [inputImage CGImage]);
        CGImageRef outputImage = CGBitmapContextCreateImage(imageContext);
        
        CGContextRelease(imageContext);
        CGColorSpaceRelease(colourSpace);
        
        UIImage *retMe  = [UIImage imageWithCGImage:outputImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
        
        CGImageRelease(outputImage);
        
        PFImageScaleMetaData *metaData = [[PFImageScaleMetaData alloc] init];
        [metaData setOriginalSize:origSize];
        [metaData setScaledSize:newSize];
        
        [retMe pf_setImageScaleMetaData:metaData];
        
        return retMe;
    };
    
    PFImageProcess *process =  [[PFImageProcess alloc] init];
    [process setBlk:blk];
    [process setCacheKey:[NSString stringWithFormat:@"SWH:%f,%f", size.width, size.height]];
    
    return process;
}

+ (PFImageProcess *)centerAndCropToSize:(CGSize)size; {
    
    PFImageLoaderPostprocessBlock blk = ^UIImage*(UIImage *inputImage) {
        
        return [PFImageLoader cropImage:inputImage size:size];
    };
    
    PFImageProcess *process =  [[PFImageProcess alloc] init];
    [process setBlk:blk];
    [process setCacheKey:[NSString stringWithFormat:@"SC:%@", NSStringFromCGSize(size)]];
    
    return process;
}

+ (PFImageProcess *)centerAndCropToCircle:(CGSize)size
                                   radius:(NSInteger)radius; {
    
    PFImageLoaderPostprocessBlock blk = ^UIImage*(UIImage *inputImage) {
        
        UIImage *image = [PFImageLoader cropImage:inputImage size:size];
        
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
        [[UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, image.size}
                                    cornerRadius:radius] addClip];
        [image drawInRect:(CGRect){CGPointZero, image.size}];
        UIImage* circle = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return circle;
    };
    
    PFImageProcess *process =  [[PFImageProcess alloc] init];
    [process setBlk:blk];
    [process setCacheKey:[NSString stringWithFormat:@"SC:%@", NSStringFromCGSize(size)]];
    
    return process;
}

+ (UIImage *)cropImage:(UIImage *)inputImage size:(CGSize)size; {
    
    CGSize scaledSize = CGSizeMake(size.width * [[UIScreen mainScreen] scale], size.height * [[UIScreen mainScreen] scale]);
    
    CGFloat origWidth = [inputImage size].width;
    CGFloat origHeight = [inputImage size].height;
    CGFloat scaleWidth;
    CGFloat scaleHeight;
    CGFloat scaleRatio;
    
    if(origWidth <= origHeight) {
        
        scaleWidth = scaledSize.width;
        scaleRatio = scaleWidth / origWidth;
        scaleHeight = scaleRatio * origHeight;
        
    } else {
        
        scaleHeight = scaledSize.height;
        scaleRatio = scaleHeight / origHeight;
        scaleWidth = scaleRatio * origWidth;
    }
    
    CGFloat shiftX = (scaleWidth - scaledSize.width) / 2.0f;
    CGFloat shiftY = (scaleHeight - scaledSize.height) / 2.0f;
    
    CGRect clipRect = CGRectMake(0.0f, 0.0f, scaledSize.width, scaledSize.height);
    CGRect destRect = CGRectMake(-shiftX, -shiftY, scaleWidth, scaleHeight);
    
    clipRect = CGRectIntegral(clipRect);
    destRect = CGRectIntegral(destRect);
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef scaleContext = CGBitmapContextCreate(NULL, scaledSize.width, scaledSize.height, 8, scaledSize.width*4, colourSpace, kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little);
    CGContextSetInterpolationQuality(scaleContext, kCGInterpolationHigh);
    CGContextClipToRect(scaleContext, clipRect);
    CGContextDrawImage(scaleContext, destRect, [inputImage CGImage]);
    CGImageRef outputImage = CGBitmapContextCreateImage(scaleContext);
    
    CGContextRelease(scaleContext);
    CGColorSpaceRelease(colourSpace);
    UIImage *retMe = [UIImage imageWithCGImage:outputImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    CGImageRelease(outputImage);
    
    return retMe;
}

- (UIImage *)preloadAndScaleImage:(UIImage *)image
                           forUrl:(NSString *)url
              withProcessingBlock:(PFImageProcess *)processingBlock; {
    
    NSString *cacheKey = [self cacheKeyForImageWithUrl:url processingBlock:processingBlock];
    
    UIImage *outputImage = image;
    
    if([processingBlock blk]) {
        outputImage = [processingBlock blk](image);
    }
    
    @synchronized(self) {
        [[self imageCache] setObject:outputImage forKey:cacheKey];
    }
    
    return outputImage;
}

- (UIImage *)getImageFromCache:(NSString *)url
           withProcessingBlock:(PFImageProcess *)processingBlock; {
    
    UIImage *img =  [[self imageCache] objectForKey:[self cacheKeyForImageWithUrl:url
                                                                  processingBlock:processingBlock]];
    return img;
}

- (void)removeSuccessBlock:(PFImageLoaderSuccessBlock)success
           forImageWithUrl:(NSString *)url
       postProcessingBlock:(PFImageProcess *)postProcessingBlock; {
    
    NSString *cacheKey = [self cacheKeyForImageWithUrl:url processingBlock:postProcessingBlock];
    
    @synchronized(self) {
        
        NSMutableArray *blocks = [[self keysToSuccessBlocks] objectForKey:cacheKey];
        
        if(blocks != nil) {
            [blocks removeObject:success];
            [[self keysToSuccessBlocks] setObject:blocks forKey:cacheKey];
        }
    }
}

-(void)addSuccessBlock:(PFImageLoaderSuccessBlock)success
       forImageWithUrl:(NSString *)url
       processingBlock:(PFImageProcess *)processingBlock; {
    
    NSString *cacheKey = [self cacheKeyForImageWithUrl:url processingBlock:processingBlock];
    
    @synchronized(self) {
        
        NSMutableArray *blocks = [[self keysToSuccessBlocks] objectForKey:cacheKey];
        if(blocks == nil) {
            blocks = [NSMutableArray array];
        }
        
        [blocks addObject:[success copy]];
        [[self keysToSuccessBlocks] setObject:blocks forKey:cacheKey];
    }
}

-(void)clearSuccessBlocksForImageWithUrl:(NSString *)url
                         processingBlock:(PFImageProcess *)processingBlock; {
    
    NSString *cacheKey = [self cacheKeyForImageWithUrl:url processingBlock:processingBlock];
    
    @synchronized(self) {
        
        [[self keysToSuccessBlocks] removeObjectForKey:cacheKey];
        if([[self keysToSuccessBlocks] count] == 0) {
            [self setKeysToSuccessBlocks:[NSMutableDictionary dictionary]];
        }
    }
}

-(void)runSuccessBlocksForImageWithUrl:(NSString *)url
                       processingBlock:(PFImageProcess *)processingBlock
                             withImage:(UIImage *)image; {
    
    NSString *cacheKey = [self cacheKeyForImageWithUrl:url processingBlock:processingBlock];
    
    @synchronized(self) {
        
        NSMutableArray *blocks = [[self keysToSuccessBlocks] objectForKey:cacheKey];
        
        if(blocks != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                for(PFImageLoaderSuccessBlock blk in blocks) {
                    blk(image);
                }
            });
        }
        
        [self clearSuccessBlocksForImageWithUrl:url processingBlock:processingBlock];
    }
}



- (void)cache:(NSCache *)cache willEvictObject:(id)obj; {
    
    NSLog(@"Eviction!");
}

-(void)cacheImageWithUrl:(NSString *)url
      withPostprocessing:(PFImageProcess *)postProcessingBlock
                 success:(PFImageLoaderSuccessBlock)success; {
    
    [self cacheImageWithUrl:url withPostprocessing:postProcessingBlock success:success retryCount:0];
}

-(void) cacheImageWithUrl:(NSString *)url
       withPostprocessing:(PFImageProcess *)postProcessingBlock
                  success:(PFImageLoaderSuccessBlock)success
               retryCount:(NSUInteger)retryCount; {
    
    @synchronized(self) {
        
        UIImage *img = [self getImageFromCache:url withProcessingBlock:postProcessingBlock];
        
        if (img) {
            
            if(success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(img);
                });
            }
            
            return;
        }
        
        
        if(success) {
            [self addSuccessBlock:success forImageWithUrl:url processingBlock:postProcessingBlock];
        }
        
        
        if([self isUrlInflight:url withProcessingBlock:postProcessingBlock]) {
            return;
        }
        
        [self makeUrlInflight:url withProcessingBlock:postProcessingBlock];
        
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFImageRequestOperation *op = [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                                       imageProcessingBlock:nil
                                                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                        if(retryCount > 0) {
                                                                                            NSLog(@"Success for %@", url);
                                                                                        }
                                                                                        dispatch_async(image_preload_and_scaling_queue(), ^{
                                                                                            [self removeUrlInflight:url withProcessingBlock:postProcessingBlock];
                                                                                            // In some very rare cases we seem to get a nil image from afnetworking
                                                                                            if(!image) {
                                                                                                if(retryCount < kMaxRetries) {
                                                                                                    [self clearSuccessBlocksForImageWithUrl:url processingBlock:postProcessingBlock];
                                                                                                    int64_t delayInSeconds = 2;
                                                                                                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                                                                                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                                                                                                        [self cacheImageWithUrl:url withPostprocessing:postProcessingBlock success:success retryCount:retryCount+1];
                                                                                                    });
                                                                                                }
                                                                                                return;
                                                                                            }
                                                                                            
                                                                                            
                                                                                            UIImage *result = [self preloadAndScaleImage:image forUrl:url withProcessingBlock:postProcessingBlock];
                                                                                            [self runSuccessBlocksForImageWithUrl:url processingBlock:postProcessingBlock withImage:result];
                                                                                        });
                                                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                        [self removeUrlInflight:url withProcessingBlock:postProcessingBlock];
                                                                                        if([[error domain] isEqualToString:NSURLErrorDomain]) {
                                                                                            if(retryCount < kMaxRetries) {
                                                                                                [self clearSuccessBlocksForImageWithUrl:url processingBlock:postProcessingBlock];
                                                                                                int64_t delayInSeconds = 2;
                                                                                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                                                                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                                                                                                    [self cacheImageWithUrl:url withPostprocessing:postProcessingBlock success:success retryCount:retryCount+1];
                                                                                                });
                                                                                                return;
                                                                                            }
                                                                                            
                                                                                        }
                                                                                        [self clearSuccessBlocksForImageWithUrl:url processingBlock:postProcessingBlock];
                                                                                    }];
    
    [op start];
}

-(void) cacheImageWithUrl:(NSString *)url
       withPostprocessing:(PFImageProcess *)postProcessingBlock; {
    
    [self cacheImageWithUrl:url
         withPostprocessing:postProcessingBlock success:NULL];
}

- (void)cacheImageWithUrl:(NSString *)url
       withPostprocessing:(PFImageProcess *)postProcessingBlock
                 progress:(PFImageLoaderProgressBlock)progressBlock
                  success:(PFImageLoaderSuccessBlock)success
                      tag:(NSInteger)tag; {
    
    [self cacheImageWithUrl:url
         withPostprocessing:postProcessingBlock
                   progress:progressBlock
                    success:success
                 retryCount:0
                        tag:tag];
}

- (void)cacheImageWithUrl:(NSString *)url
       withPostprocessing:(PFImageProcess *)postProcessingBlock
                 progress:(PFImageLoaderProgressBlock)progressBlock
                  success:(PFImageLoaderSuccessBlock)success
               retryCount:(NSUInteger)retryCount
                      tag:(NSInteger)tag; {
    
    @synchronized(self) {
        
        UIImage *img = [self getImageFromCache:url withProcessingBlock:postProcessingBlock];
        
        if (img) {
            
            if(success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(img);
                });
            }
            
            if(progressBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progressBlock(tag, 0, 0, 0);
                });
            }
            
            return;
        }
        
        if(success) {
            
            [self addSuccessBlock:success
                  forImageWithUrl:url
                  processingBlock:postProcessingBlock];
        }
        
        [self makeUrlInflight:url withProcessingBlock:postProcessingBlock];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFImageRequestOperation *op = [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                                       imageProcessingBlock:nil
                                                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                        if(retryCount > 0) {
                                                                                            NSLog(@"Success for %@", url);
                                                                                        }
                                                                                        dispatch_async(image_preload_and_scaling_queue(), ^{
                                                                                            [self removeUrlInflight:url withProcessingBlock:postProcessingBlock];
                                                                                            if(!image) {
                                                                                                if(retryCount < kMaxRetries) {
                                                                                                    [self clearSuccessBlocksForImageWithUrl:url processingBlock:postProcessingBlock];
                                                                                                    int64_t delayInSeconds = 2;
                                                                                                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                                                                                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                                                                                                        [self cacheImageWithUrl:url withPostprocessing:postProcessingBlock success:success retryCount:retryCount+1];
                                                                                                    });
                                                                                                }
                                                                                                return;
                                                                                            }
                                                                                            UIImage *result = [self preloadAndScaleImage:image forUrl:url withProcessingBlock:postProcessingBlock];
                                                                                            [self runSuccessBlocksForImageWithUrl:url processingBlock:postProcessingBlock withImage:result];
                                                                                        });
                                                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                        [self removeUrlInflight:url withProcessingBlock:postProcessingBlock];
                                                                                        if([[error domain] isEqualToString:NSURLErrorDomain]) {
                                                                                            if(retryCount < kMaxRetries) {
                                                                                                [self clearSuccessBlocksForImageWithUrl:url processingBlock:postProcessingBlock];
                                                                                                int64_t delayInSeconds = 2;
                                                                                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                                                                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                                                                                                    [self cacheImageWithUrl:url withPostprocessing:postProcessingBlock success:success retryCount:retryCount+1];
                                                                                                });
                                                                                                return;
                                                                                            }
                                                                                            
                                                                                        }
                                                                                        [self clearSuccessBlocksForImageWithUrl:url processingBlock:postProcessingBlock];
                                                                                    }];
    
    if(progressBlock) {
    
        [op setDownloadProgressBlock:^(NSUInteger bytesRead,
                                       long long totalBytesRead,
                                       long long totalBytesExpectedToRead) {
            
            progressBlock(tag, bytesRead, totalBytesRead, totalBytesExpectedToRead);
        }];
    }
    
    [op start];
}

- (void)cacheImageWithHash:(NSString *)hash
                     image:(UIImage *)image
        withPostprocessing:(PFImageProcess *)postProcessingBlock
                   success:(PFImageLoaderSuccessBlock)success; {
    
    @synchronized(self) {
        
        UIImage *img = [self getImageFromCache:hash withProcessingBlock:postProcessingBlock];
        
        if (img) {
            
            if(success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(img);
                });
            }
            
            return;
        }
        
        if(success) {
            
            [self addSuccessBlock:success
                  forImageWithUrl:hash
                  processingBlock:postProcessingBlock];
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
    
        UIImage *result = [self preloadAndScaleImage:image
                                              forUrl:hash
                                 withProcessingBlock:postProcessingBlock];
        
        [self runSuccessBlocksForImageWithUrl:hash
                              processingBlock:postProcessingBlock
                                    withImage:result];
    });
}

@end