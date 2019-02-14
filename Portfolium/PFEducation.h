//
//  PFEducation.h
//  Portfolium
//
//  Created by John Eisberg on 11/26/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"
#import "PFFilename.h"

@interface PFEducation : NSObject<PFModel>

@property(nonatomic, strong) NSNumber *educationId;
@property(nonatomic, strong) NSString *school;
@property(nonatomic, strong) NSString *major;
@property(nonatomic, strong) NSString *gradYear;
@property(nonatomic, strong) NSString *degree;
@property(nonatomic, strong) NSString *gpa;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) NSNumber *current;
@property(nonatomic, strong) NSDate *createdAt;
@property(nonatomic, strong) NSDate *updatedAt;
@property(nonatomic, strong) PFFilename *image;

@end