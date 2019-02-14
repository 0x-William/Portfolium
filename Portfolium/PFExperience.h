//
//  PFExperience.h
//  Portfolium
//
//  Created by John Eisberg on 11/26/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"
#import "PFFilename.h"

@interface PFExperience : NSObject<PFModel>

@property(nonatomic, strong) NSNumber *experienceId;
@property(nonatomic, strong) NSString *company;
@property(nonatomic, strong) NSString *position;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) NSString *startDate;
@property(nonatomic, strong) NSString *endDate;
@property(nonatomic, strong) NSDate *createdAt;
@property(nonatomic, strong) NSDate *updatedAt;
@property(nonatomic, strong) PFFilename *image;

@end