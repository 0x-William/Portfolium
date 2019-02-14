//
//  PFInterests.h
//  Portfolium
//
//  Created by John Eisberg on 8/1/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"

@interface PFInterests : NSObject<PFModel>

@property(nonatomic, strong) NSArray *categoryIds;

- (NSMutableDictionary *) categoryIdsToDictionary;

@end
