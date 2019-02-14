//
//  PFClassification.m
//  Portfolium
//
//  Created by John Eisberg on 8/1/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFClassification.h"
#import "RKObjectMapping.h"
#import "PFIAmAVC.h"

static NSString *const kPortfoliumType = @"unknown";
static NSString *const kUndergradType = @"undergrad";
static NSString *const kGradStudentType = @"grad";
static NSString *const kCommunityCollegeType = @"communitycollege";
static NSString *const kHighSchoolType = @"highschool";
static NSString *const kAlumniType = @"alumni";
static NSString *const kProfessorType = @"professor";
static NSString *const kEmployerType = @"employer";

NSString *const kHighSchoolTypeReadable = @"High School Student";
NSString *const kUndergradTypeReadable = @"Undergraduate Student";
NSString *const kGradStudentTypeReadable = @"Graduate Student";
NSString *const kCommunityCollegeTypeReadable = @"Community College Student";
NSString *const kAlumniTypeReadable = @"Alumni";
NSString *const kPortfoliumTypeReadable = @"I just want a Portfolium";
NSString *const kProfessorTypeReadable = @"Professor";
NSString *const kEmployerTypeReadable = @"Employer";

@implementation PFClassification

+ (NSString *)endPoint; {
    
    return @"/users/classification";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"classification" : @"classification" }];
    
    return mapping;
}

+ (NSString *)mapType:(NSString *)type; {
    
    if([type isEqualToString:kPortfoliumTypeReadable]) {
        return kPortfoliumType;
    } else if([type isEqualToString:kHighSchoolTypeReadable]) {
        return kHighSchoolType;
    } else if([type isEqualToString:kUndergradTypeReadable]) {
        return kUndergradType;
    } else if([type isEqualToString:kCommunityCollegeTypeReadable]) {
        return kCommunityCollegeType;
    } else if([type isEqualToString:kGradStudentTypeReadable]) {
        return kGradStudentType;
    } else if ([type isEqualToString:kProfessorTypeReadable]) {
        return kProfessorType;
    } else if ([type isEqualToString:kEmployerTypeReadable]) {
        return kEmployerType;
    } else {
        return kUndergradType;
    }
}

+ (NSString *)mapReadable:(NSNumber *)type; {
    
    if([type integerValue] == PFClassificationTypeUnknown) {
        return kPortfoliumTypeReadable;
    } else if([type integerValue] == PFClassificationTypeUnderGrad) {
        return kUndergradTypeReadable;
    } else if([type integerValue] == PFClassificationTypeGrad) {
        return kGradStudentTypeReadable;
    } else if([type integerValue] == PFClassificationTypeCommunityCollege) {
        return kCommunityCollegeTypeReadable;
    } else if([type integerValue] == PFClassificationTypeHighSchool) {
        return kHighSchoolTypeReadable;
    } else if([type integerValue] == PFClassificationTypeAlumni) {
        return kAlumniTypeReadable;
    } else if([type integerValue] == PFClassificationTypeProfessor) {
        return kProfessorTypeReadable;
    } else {
        return kEmployerTypeReadable;
    }
}

@end
