//
//  NSDate+PFExtensions.h
//  Portfolium
//
//  Created by John Eisberg on 12/11/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (PFExtentions)

- (NSString *)apiDateFormatToReadableString;

- (NSString *)toString;
    
@end