//
//  PFMajor.h
//  Portfolium
//
//  Created by John Eisberg on 7/30/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"
#import "PFIndexable.h"

@interface PFMajor : NSObject<PFModel, PFIndexable>

@property(nonatomic, strong) NSString *name;

@end