//
//  PFStatus.m
//  Portfolium
//
//  Created by John Eisberg on 10/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFStatus.h"
#import "RKObjectMapping.h"

NSString *kConnect = @"connect";
NSString *kPending = @"pending";
NSString *kConnected = @"connected";
NSString *kAccept = @"accept";

@implementation PFStatus

+ (NSString *)endPoint; {
    
    return @"";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"status" : @"status",
                                                   @"token" : @"token" }];
    
    return mapping;
}

@end