//
//  PFCollaborator.h
//  Portfolium
//
//  Created by John Eisberg on 11/16/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"
#import "PFIndexable.h"

@interface PFCollaborator : NSObject<PFModel, PFIndexable>

@property(nonatomic, strong) NSNumber *collaboratorId;
@property(nonatomic, strong) NSString *name;

+ (NSString *)endPointUser;

- (NSString *)endPointUserPath;

@end
