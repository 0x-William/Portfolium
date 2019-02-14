//
//  PFOnboarding.m
//  Portfolium
//
//  Created by John Eisberg on 8/1/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFOnboarding.h"
#import "RKObjectMapping.h"
#import "NSString+PFExtensions.h"
#import "NSDate+PFExtensions.h"
#import "PFClassification.h"
#import "PFAuthenticationProvider.h"

static const NSString *kWhoIAm = @"type";
static const NSString *kSchool = @"school";
static const NSString *kFieldOfStudy = @"major";
static const NSString *kGraduationYear = @"year";

static const NSString *kFirstname = @"firstname";
static const NSString *kLastname = @"lastname";
static const NSString *kUsername = @"username";
static const NSString *kLocation = @"location";
static const NSString *kTagline = @"tagline";
static const NSString *kGender = @"gender";
static const NSString *kBirthdate = @"birthday";

@implementation PFOnboarding

+ (PFOnboarding *)shared; {
    
    static dispatch_once_t once;
    static PFOnboarding *shared;
    
    dispatch_once(&once, ^{
        
        shared = [[PFOnboarding alloc] init];
        
        [shared makeEmpty];
    });
    
    return shared;
}

- (void)init:(PFAuthenticationProvider *)provider; {
    
    [self clear];
    
    if([[provider type] integerValue] == 0) {
        [self setWhoIAm:nil];
    } else {
        [self setWhoIAm:[PFClassification mapReadable:[provider type]]];
    }
    
    if([provider birthday] != nil) {
        [self setBirthdate:[provider birthday]];
    }
    
    if(![NSString isNullOrEmpty:[provider school]]) {
        [self setSchool:[provider school]];
    } else {
        [self setSchool:[NSString empty]];
    }
    
    if(![NSString isNullOrEmpty:[provider major]]) {
        [self setFieldOfStudy:[provider major]];
    } else {
        [self setFieldOfStudy:[NSString empty]];
    }
    
    if(![NSString isNullOrEmpty:[provider firstname]]) {
        [self setFirstname:[provider firstname]];
    } else {
        [self setFirstname:[NSString empty]];
    }
    
    if(![NSString isNullOrEmpty:[provider lastname]]) {
        [self setLastname:[provider lastname]];
    } else {
        [self setLastname:[NSString empty]];
    }
    
    if(![NSString isNullOrEmpty:[provider username]]) {
        [self setUsername:[provider username]];
    } else {
        [self setUsername:[NSString empty]];
    }
    
    if(![NSString isNullOrEmpty:[provider gender]]) {
        [self setGender:[provider gender]];
    } else {
        [self setGender:[NSString empty]];
    }
    
    if(![NSString isNullOrEmpty:[provider location]]) {
        [self setLocation:[provider location]];
    } else {
        [self setLocation:[NSString empty]];
    }
    
    if(![NSString isNullOrEmpty:[provider tagline]]) {
        [self setTagline:[provider tagline]];
    } else {
        [self setTagline:[NSString empty]];
    }
}

- (void)clear; {
    
    [self makeEmpty];
}

- (void)makeEmpty; {
    
    [self setCategories:[[NSMutableArray alloc] init]];
    [self setWhoIAm:[NSString empty]];
    [self setSchool:[NSString empty]];
    [self setFieldOfStudy:[NSString empty]];
    [self setGraduationYear:[NSString empty]];
    [self setFirstname:[NSString empty]];
    [self setLastname:[NSString empty]];
    [self setUsername:[NSString empty]];
    [self setLocation:[NSString empty]];
    [self setTagline:[NSString empty]];
    [self setGender:[NSString empty]];
}

+ (NSString *)endPoint; {
    
    return @"/users/profile";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ kFirstname : kFirstname,
                                                   kLastname : kLastname,
                                                   kUsername : kUsername,
                                                   kLocation : kLocation,
                                                   kTagline : kTagline,
                                                   kGender : kGender,
                                                   kBirthdate : kBirthdate}];
    return mapping;
}

- (NSMutableDictionary *)buildEducationParameters; {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    if(![NSString isNullOrEmpty:[self whoIAm]]) {
        
        NSString *mappedType = [PFClassification mapType:[self whoIAm]];
        [parameters setObject:mappedType forKey:kWhoIAm];
    
    } else {
        [parameters setObject:[NSString empty] forKey:kWhoIAm];
    }
    
    if(![NSString isNullOrEmpty:[self school]]) {
        [parameters setObject:[self school] forKey:kSchool];
    } else {
        [parameters setObject:[NSString empty] forKey:kSchool];
    }
    
    if(![NSString isNullOrEmpty:[self fieldOfStudy]]) {
        [parameters setObject:[self fieldOfStudy] forKey:kFieldOfStudy];
    } else {
        [parameters setObject:[NSString empty] forKey:kFieldOfStudy];
        
    }
    
    if(![NSString isNullOrEmpty:[self graduationYear]]) {
        [parameters setObject:[self graduationYear] forKey:kGraduationYear];
    } else {
        [parameters setObject:[NSString empty] forKey:kGraduationYear];
    }
    
    return parameters;
}

- (NSMutableDictionary *)buildBasicsParameters; {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    if(![NSString isNullOrEmpty:[self firstname]]) {
        [parameters setObject:[self firstname] forKey:kFirstname];
    } else {
        [parameters setObject:[NSString empty] forKey:kFirstname];
    }
    
    if(![NSString isNullOrEmpty:[self lastname]]) {
        [parameters setObject:[self lastname] forKey:kLastname];
    } else {
        [parameters setObject:[NSString empty] forKey:kLastname];
    }
    
    if(![NSString isNullOrEmpty:[self username]]) {
        [parameters setObject:[self username] forKey:kUsername];
    } else {
        [parameters setObject:[NSString empty] forKey:kUsername];
    }
    
    if(![NSString isNullOrEmpty:[self location]]) {
        [parameters setObject:[self location] forKey:kLocation];
    } else {
        [parameters setObject:[NSString empty] forKey:kLocation];
    }
    
    if(![NSString isNullOrEmpty:[self tagline]]) {
        [parameters setObject:[self tagline] forKey:kTagline];
    } else {
        [parameters setObject:[NSString empty] forKey:kTagline];
    }
    
    if(![NSString isNullOrEmpty:[self gender]]) {
        [parameters setObject:[self gender] forKey:kGender];
    } else {
        [parameters setObject:[NSString empty] forKey:kGender];
    }
    
    if([self birthdate] != nil) {
        [parameters setObject:[[self birthdate] apiDateFormatToReadableString] forKey:kBirthdate];
    } else {
        [parameters setObject:@"" forKey:kBirthdate];
    }
    
    return parameters;
}

@end