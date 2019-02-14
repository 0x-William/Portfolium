//
//  PFCount.h
//  Portfolium
//
//  Created by John Eisberg on 12/18/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"

@interface PFCount : NSObject<PFModel>

@property(nonatomic, strong) NSNumber *notifications;
@property(nonatomic, strong) NSNumber *messages;
@property(nonatomic, strong) NSNumber *entries;

@end