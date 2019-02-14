//
//  PFClassification.h
//  Portfolium
//
//  Created by John Eisberg on 8/1/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"

FOUNDATION_EXPORT NSString *const kHighSchoolTypeReadable;
FOUNDATION_EXPORT NSString *const kUndergradTypeReadable;
FOUNDATION_EXPORT NSString *const kGradStudentTypeReadable;
FOUNDATION_EXPORT NSString *const kCommunityCollegeTypeReadable;
FOUNDATION_EXPORT NSString *const kAlumniTypeReadable;
FOUNDATION_EXPORT NSString *const kPortfoliumTypeReadable;
FOUNDATION_EXPORT NSString *const kProfessorTypeReadable;
FOUNDATION_EXPORT NSString *const kEmployerTypeReadable;

@interface PFClassification : NSObject<PFModel>

typedef enum {
    
    PFClassificationTypeUnknown,
    PFClassificationTypeUnderGrad,
    PFClassificationTypeGrad,
    PFClassificationTypeCommunityCollege,
    PFClassificationTypeHighSchool,
    PFClassificationTypeAlumni,
    PFClassificationTypeProfessor,
    PFClassificationTypeEmployer,
    
} PFClassificationType;

@property(nonatomic, strong) NSString *classification;

+ (NSString *)mapType:(NSString *)type;

+ (NSString *)mapReadable:(NSNumber *)type;

@end
