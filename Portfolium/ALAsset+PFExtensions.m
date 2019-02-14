//
//  ALAsset+PFExtensions.m
//  Portfolium
//
//  Created by John Eisberg on 12/9/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "ALAsset+PFExtensions.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@implementation ALAsset (PFExtensions)

- (NSURL*)defaultURL {
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        return [self valueForKey: ALAssetPropertyAssetURL];
    } else {
        return self.defaultRepresentation.url;
    }
}

- (BOOL)isEqual:(id)obj {
    
    if(![obj isKindOfClass:[ALAsset class]]) {
        return NO;
    }
    
    NSURL *u1 = [self defaultURL];
    NSURL *u2 = [obj defaultURL];
    
    return [u1 isEqual:u2];
}

@end