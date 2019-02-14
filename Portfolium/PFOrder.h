//
//  PFOrder.h
//  Portfolium
//
//  Created by John Eisberg on 12/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"

@interface PFOrder : NSObject<PFModel>

@property(nonatomic, assign) NSInteger accomplishments;
@property(nonatomic, assign) NSInteger affiliations;
@property(nonatomic, assign) NSInteger athletics;
@property(nonatomic, assign) NSInteger awards;
@property(nonatomic, assign) NSInteger certifications;
@property(nonatomic, assign) NSInteger courses;
@property(nonatomic, assign) NSInteger educations;
@property(nonatomic, assign) NSInteger experiences;
@property(nonatomic, assign) NSInteger extracurriculars;
@property(nonatomic, assign) NSInteger milestones;
@property(nonatomic, assign) NSInteger publications;
@property(nonatomic, assign) NSInteger skills;
@property(nonatomic, assign) NSInteger volunteers;
@property(nonatomic, strong) NSDate *createdAt;
@property(nonatomic, strong) NSDate *updatedAt;

@end