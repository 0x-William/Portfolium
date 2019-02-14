//
//  UIImage+PFExtensions.m
//  Portfolium
//
//  Created by John Eisberg on 1/7/15.
//  Copyright (c) 2015 Portfolium. All rights reserved.
//

#import "UIImage+PFExtensions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation UIImage (PFExtentions)

- (NSString *)hash; {
    
    unsigned char hash[CC_MD5_DIGEST_LENGTH];
    
    [self md5HashFromUIImage:self hash:hash];
    
    return [[NSString alloc] initWithBytes:hash
                                    length:sizeof(hash)
                                  encoding:NSASCIIStringEncoding];
}

- (void)md5HashFromUIImage:(UIImage*)image
                      hash:(unsigned char*)hash; {
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(image.CGImage);
    NSData *data = (NSData*)CFBridgingRelease(CGDataProviderCopyData(dataProvider));
    CC_MD5([data bytes], [data length], hash);
}

- (BOOL)compareUIImages:(UIImage*)image1
                  image:(UIImage*)image2; {
    
    unsigned char hash1[CC_MD5_DIGEST_LENGTH];
    unsigned char hash2[CC_MD5_DIGEST_LENGTH];
    
    [self md5HashFromUIImage:image1 hash:hash1];
    [self md5HashFromUIImage:image2 hash:hash2];
    
    return memcmp(hash1, hash2, CC_MD5_DIGEST_LENGTH) == 0;
}

@end