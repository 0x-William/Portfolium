//
//  PFDateUtils.m
//  Portfolium
//
//  Created by John Eisberg on 10/1/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFDateUtils.h"

@implementation PFDateUtils

+ (NSString *)dateStringToDateString:(NSString *)dateString; {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setDateFormat:@"h:mm a - MMMM d yyyy"];
    
    return [dateFormatter stringFromDate:date];
}

@end
