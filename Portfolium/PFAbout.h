//
//  PFAbout.h
//  Portfolium
//
//  Created by John Eisberg on 11/26/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"
#import "PFOrder.h"

@interface PFAbout : NSObject<PFModel>

@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, strong) NSArray *interests;
@property(nonatomic, strong) NSArray *accomplishments;
@property(nonatomic, strong) NSArray *affiliations;
@property(nonatomic, strong) NSArray *athletics;
@property(nonatomic, strong) NSArray *awards;
@property(nonatomic, strong) NSArray *certifications;
@property(nonatomic, strong) NSArray *courses;
@property(nonatomic, strong) NSArray *educations;
@property(nonatomic, strong) NSArray *experiences;
@property(nonatomic, strong) NSArray *extracurriculars;
@property(nonatomic, strong) NSArray *milestones;
@property(nonatomic, strong) NSArray *publications;
@property(nonatomic, strong) NSArray *skills;
@property(nonatomic, strong) NSArray *volunteers;
@property(nonatomic, strong) PFOrder *order;

+ (NSString *)endPointWithUserId;

- (NSString *)endPointWithUserIdPath;

- (NSInteger)numberOfItems;

@end
