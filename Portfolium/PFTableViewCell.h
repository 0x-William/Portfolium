//
//  PFTableViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 7/27/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PFTableViewCell <NSObject>

+ (NSString *)preferredReuseIdentifier;

@end