//
//  NSDate+PFExtensions.m
//  Portfolium
//
//  Created by John Eisberg on 12/11/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "NSDate+PFExtensions.h"

@implementation NSDate (PFExtentions)

- (NSString *)apiDateFormatToReadableString; {
    
    NSDateFormatter *readableFormat = [[NSDateFormatter alloc] init];
    
    [readableFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [readableFormat setDateFormat:@"MM/dd/yyyy"];
    
    return [readableFormat stringFromDate:self];
}

- (NSString *)toString; {
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:self
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    return dateString;
}

@end