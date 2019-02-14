//
//  NSURL+PFExtensions.m
//  Portfolium
//
//  Created by John Eisberg on 8/26/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "NSURL+PFExtensions.h"
#import "NSString+PFExtensions.h"

@implementation NSURL (ASExtensions)

- (BOOL)isProfileURL; {
    
    BOOL isInAppUserURL = NO;
    NSArray *split = [NSString split:[self absoluteString] onToken:@":"];
    if([split count] == 2) {
        NSString *protocol = [split objectAtIndex:0];
        if([protocol isEqualToString:@"user"]) {
            isInAppUserURL = YES;
        }
    } return isInAppUserURL;
}

- (NSNumber *)getUserId; {
    
    NSNumber *targetId = [NSNumber numberWithInt:0];
    NSArray *split = [NSString split:[self absoluteString] onToken:@":"];
    if([split count] == 2) {
        NSString *string = [split objectAtIndex:1];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        targetId = [f numberFromString:string];
    } return targetId;
}

@end
