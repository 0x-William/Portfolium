//
//  PFEntry.m
//  Portfolium
//
//  Created by John Eisberg on 8/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFEntry.h"
#import "RKObjectMapping.h"

static NSString *kEntryTypeJob = @"job";
static NSString *kEntryTypeCourseWork = @"course";
static NSString *kEntryTypeVolunteer = @"volunteer";
static NSString *kEntryTypeClubs = @"clubs";
static NSString *kEntryTypeHobbies = @"hobbies";
static NSString *kEntryTypeMisc = @"misc";

@implementation PFEntry

+ (NSString *)endPointForWebEntry:(NSNumber *)entryId; {
    
    return [NSString stringWithFormat:@"https://portfolium.com/e/%@", [entryId stringValue]];
}

+ (NSString *)endPoint; {
    
    return @"/entries/interests";
}

+ (NSString *)endPointWithCategoryId; {
    
    return @"/entries/category/:fk_category_id";
}

+ (NSString *)endPointWithUserId; {
    
    return @"/entries/user/:fk_user_id";
}

+ (NSString *)endPointWithTag; {
    
    return @"/entries/hashtag/:tag";
}

+ (NSString *)endPointWithEntryId; {
    
    return @"/entries/entry/:id";
}

+ (NSString *)endPointLikeWithEntryId; {
 
    return @"/entries/like/:id";
}

+ (NSString *)endPointSearch; {
    
    return @"/search/entries";
}

+ (NSString *)endPointCreate; {
    
    return @"/entries/create";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"id" : @"entryId",
                                                   @"fk_user_id" : @"userId",
                                                   @"title" : @"title",
                                                   @"description" : @"caption",
                                                   @"type" : @"type",
                                                   @"fk_category_id" : @"categoryId",
                                                   @"fk_university_id" : @"universityId",
                                                   @"fk_course_id" : @"courseId",
                                                   @"slideshare_url" : @"slideshareUrl",
                                                   @"slideshare_id" : @"slideshareId",
                                                   @"sketchFab" : @"sketchFab",
                                                   @"prezi" : @"prezi",
                                                   @"views" : @"views",
                                                   @"likes" : @"likes",
                                                   @"visibility" : @"visibility",
                                                   @"allow_comments" : @"allowComments",
                                                   @"order" : @"order",
                                                   @"liked" : @"liked",
                                                   @"comments" : @"commentCount",
                                                   @"created_at" : @"createdAt",
                                                   @"updated_at" : @"updatedAt"}];
    
    return mapping;
}

+ (NSString *)entryTypeToString:(PFEntryType)entryType; {
    
    if(entryType == PFEntryTypeJob) {
        
        return kEntryTypeJob;
        
    } else if(entryType == PFEntryTypeCourseWork) {
        
        return kEntryTypeCourseWork;
        
    } else if(entryType == PFEntryTypeVolunteer) {
        
        return kEntryTypeVolunteer;
        
    } else if(entryType == PFEntryTypeClubs) {
        
        return kEntryTypeClubs;
        
    } else if(entryType == PFEntryTypeHobbies) {
        
        return kEntryTypeHobbies;
        
    } else {
        
        return kEntryTypeMisc;
    }
}

- (NSString *)endPointWithCategoryIdPath; {
    
    if([self categoryId] == nil) {
        [self setCategoryId:@0];
    }
    
    return [[PFEntry endPointWithCategoryId] stringByReplacingOccurrencesOfString:@":fk_category_id"
                                                                       withString:[[self categoryId] stringValue]];
}

- (NSString *)endPointWithUserIdPath; {
    
    if([self userId] == nil) {
        [self setUserId:@0];
    }
    
    return [[PFEntry endPointWithUserId] stringByReplacingOccurrencesOfString:@":fk_user_id"
                                                                       withString:[[self userId] stringValue]];
}

- (NSString *)endPointWithTag:(NSString *)tag; {
    
    if(tag == nil) {
        tag = @"0";
    }
    
    return [[PFEntry endPointWithTag] stringByReplacingOccurrencesOfString:@":tag"
                                                                withString:tag];
}

- (NSString *)endPointWithEntryIdPath; {
    
    if([self entryId] == nil) {
        [self setEntryId:@0];
    }
    
    return [[PFEntry endPointWithEntryId] stringByReplacingOccurrencesOfString:@":id"
                                                                    withString:[[self entryId] stringValue]];
}

- (NSString *)endPointLikeWithEntryIdPath; {
    
    if([self entryId] == nil) {
        [self setEntryId:@0];
    }
    
    return [[PFEntry endPointLikeWithEntryId] stringByReplacingOccurrencesOfString:@":id"
                                                                        withString:[[self entryId] stringValue]];
}

@end
