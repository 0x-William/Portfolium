//
//  PFEntry.h
//  Portfolium
//
//  Created by John Eisberg on 8/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"
#import "PFProfile.h"
#import "PFMedia.h"
#import "PFTag.h"

typedef enum {
    
    PFEntryTypeJob,
    PFEntryTypeCourseWork,
    PFEntryTypeVolunteer,
    PFEntryTypeClubs,
    PFEntryTypeHobbies,
    PFEntryTypeMisc
    
} PFEntryType;

@interface PFEntry : NSObject<PFModel>

@property(nonatomic, strong) NSNumber *entryId;
@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *caption;
@property(nonatomic, strong) NSNumber *type;
@property(nonatomic, strong) NSNumber *categoryId;
@property(nonatomic, strong) NSNumber *universityId;
@property(nonatomic, strong) NSNumber *courseId;
@property(nonatomic, strong) NSString *slideshareUrl;
@property(nonatomic, strong) NSNumber *slideshareId;
@property(nonatomic, strong) NSString *sketchFab;
@property(nonatomic, strong) NSString *prezi;
@property(nonatomic, strong) NSNumber *views;
@property(nonatomic, strong) NSNumber *likes;
@property(nonatomic, strong) NSNumber *commentCount;
@property(nonatomic, strong) NSNumber *visibility;
@property(nonatomic, strong) NSNumber *allowComments;
@property(nonatomic, strong) NSNumber *order;
@property(nonatomic, strong) NSDate *createdAt;
@property(nonatomic, strong) NSDate *updatedAt;
@property(nonatomic, strong) PFProfile *profile;
@property(nonatomic, strong) NSMutableArray *comments;
@property(nonatomic, strong) NSArray *tags;
@property(nonatomic, strong) NSMutableArray *media;
@property(nonatomic, strong) NSNumber *liked;
@property(nonatomic, strong) NSMutableArray *likers;
@property(nonatomic, strong) NSArray *collaborators;
@property(nonatomic, strong) PFStatus *status;

+ (NSString *)endPointForWebEntry:(NSNumber *)entryId;

+ (NSString *)endPointWithCategoryId;
+ (NSString *)endPointWithUserId;
+ (NSString *)endPointWithTag;
+ (NSString *)endPointWithEntryId;
+ (NSString *)endPointLikeWithEntryId;
+ (NSString *)endPointSearch;
+ (NSString *)endPointCreate;

- (NSString *)endPointWithCategoryIdPath;
- (NSString *)endPointWithUserIdPath;
- (NSString *)endPointWithTag:(NSString *)tag;
- (NSString *)endPointWithEntryIdPath;
- (NSString *)endPointLikeWithEntryIdPath;

+ (NSString *)entryTypeToString:(PFEntryType)entryType;

@end

