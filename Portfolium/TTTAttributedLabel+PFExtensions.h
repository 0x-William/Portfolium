//
//  UILabel+PFExtensions.h
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTTAttributedLabel.h"
#import "PFProfile.h"

@interface TTTAttributedLabel (PFExtentions)

- (void)setText:(NSString *)text enbolden:(NSString *)string;

- (void)link:(NSString *)text to:(NSString *)url;

- (void)add:(PFProfile *)profile;

- (void)setDate:(NSDate *)date;

@end
