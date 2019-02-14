//
//  PFFilename.m
//  Portfolium
//
//  Created by John Eisberg on 8/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFFilename.h"
#import "RKObjectMapping.h"
#import "PFSize.h"

@implementation PFFilename

+ (NSString *)endPoint; {
    
    return @"";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"dynamic" : @"dynamic",
                                                   @"dynamic_https" : @"dynamicHttps",
                                                   @"url" : @"url",
                                                   @"urlHttps" : @"urlHttps" }];
    
    return mapping;
}

- (NSString *)croppedToSize:(CGSize)size; {
    
    CGSize adjustedSize = [PFSize adjustedImageSize:size];
    
    NSString *sze = [NSString stringWithFormat:@"%dx%d",
                     (int)roundf(adjustedSize.width),
                     (int)roundf(adjustedSize.height)];
    
    NSString* croppedToSize = [[self dynamic] stringByReplacingOccurrencesOfString:@"{function}"
                                                                        withString:@"crop"];
    
    return [croppedToSize stringByReplacingOccurrencesOfString:@"{size}"
                                                    withString:sze];
}

@end
