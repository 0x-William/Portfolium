//
//  NSString+PFExtensions.h
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PFExtentions)

+ (NSString *)empty;

+ (BOOL)isNullOrEmpty:(NSString *)string;

+ (NSArray *)split:(NSString *)string
           onToken:(NSString *)token;

+ (NSString *)join:(NSArray *)string
         withToken:(NSString *)token;

- (NSString *)trim;

- (NSString *)trimInside;

- (NSString *)commaDelimit;

@end
