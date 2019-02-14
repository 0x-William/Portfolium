//
//  NSString+PFExtensions.m
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "NSString+PFExtensions.h"

@implementation NSString (PFExtentions)

+ (NSString *)empty; {
    
    return @"";
}

+ (BOOL)isNullOrEmpty:(NSString *)string; {
    
    return string == nil || [[string trim] length] == 0;
}

+ (NSArray *)split:(NSString *)string
           onToken:(NSString *)token; {
    
    return [string componentsSeparatedByString:token];
}

+ (NSString *)join:(NSArray *)array
         withToken:(NSString *)token; {
    
    return [array componentsJoinedByString:token];
}

- (NSString *)trim; {
    
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimInside; {
    
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [self componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    
    return [filteredArray componentsJoinedByString:@" "];
}

- (NSString *)commaDelimit; {
    
    NSString *trimmed = [self trimInside];
    NSString *replaced = [trimmed stringByReplacingOccurrencesOfString:@" " withString:@","];
    
    return replaced;
}

@end