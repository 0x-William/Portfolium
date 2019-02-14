//
//  PFOnboarding.h
//  Portfolium
//
//  Created by John Eisberg on 8/1/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"

@class RKObjectMapping;
@class PFAuthenticationProvider;


@interface PFOnboarding : NSObject<PFModel>

@property(nonatomic, strong) NSMutableArray *categories;

@property(nonatomic, strong) NSString *whoIAm;
@property(nonatomic, strong) NSString *school;
@property(nonatomic, strong) NSString *fieldOfStudy;
@property(nonatomic, strong) NSString *graduationYear;

@property(nonatomic, strong) NSString *firstname;
@property(nonatomic, strong) NSString *lastname;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *location;
@property(nonatomic, strong) NSString *tagline;
@property(nonatomic, strong) NSString *gender;
@property(nonatomic, strong) NSDate *birthdate;

+ (PFOnboarding *)shared;
- (void)init:(PFAuthenticationProvider *)provider;
- (void)clear;

- (NSMutableDictionary *)buildEducationParameters;
- (NSMutableDictionary *)buildBasicsParameters;

@end