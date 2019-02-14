//
//  PFApi.h
//  Portfolium
//
//  Created by John Eisberg on 6/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFApiTypes.h"

@interface PFApi : NSObject

+ (PFApi *)shared;

- (void)setAuthenticated:(NSString *)token;
- (void)setUnauthenticated;

- (void)getTokenWithFacebook:(NSString *)token
                    referral:(NSString *)referral
                     success:(PFApiUserSuccessBlock)success
                     failure:(PFApiErrorHandlerBlock)failure;

- (void)getTokenWithTwitter:(NSString *)token
                     secret:(NSString *)secret
                   referral:(NSString *)referral
                    success:(PFApiUserSuccessBlock)success
                    failure:(PFApiErrorHandlerBlock)failure;

- (void)getTokenWithLinkedIn:(NSString *)token
                    referral:(NSString *)referral
                     success:(PFApiUserSuccessBlock)success
                     failure:(PFApiErrorHandlerBlock)failure;

- (void)signUp:(NSString *)email
      username:(NSString *)username
     firstname:(NSString *)firstname
      lastname:(NSString *)lastname
      password:(NSString *)password
      referral:(NSString *)referral
       success:(PFApiUserSuccessBlock)success
       failure:(PFApiErrorHandlerBlock)failure;

- (void)login:(NSString *)identity
     password:(NSString *)password
      success:(PFApiUserSuccessBlock)success
      failure:(PFApiErrorHandlerBlock)failure;

- (void)me:(PFApiUserSuccessBlock)success
   failure:(PFApiErrorHandlerBlock)failure;

- (void)getUserWithId:(NSNumber *)userId
              success:(PFApiUserSuccessBlock)success
              failure:(PFApiResponseBlock)failure;

- (void)linkUserWithDomain:(NSString *)domain
                     token:(NSString *)token
                    secret:(NSString *)secret
                   success:(PFApiUserSuccessBlock)success
                   failure:(PFApiErrorHandlerBlock)failure;

- (void)users:(NSInteger)page
      success:(PFApiFeedSuccessBlock)success
      failure:(PFApiErrorHandlerBlock)failure;

- (void)systemCategories:(PFApiFeedSuccessBlock)success
                 failure:(PFApiErrorHandlerBlock)failure;

- (void)highSchools:(PFApiFeedSuccessBlock)success
            failure:(PFApiErrorHandlerBlock)failure;

- (void)communityColleges:(PFApiFeedSuccessBlock)success
         failure:(PFApiErrorHandlerBlock)failure;

- (void)colleges:(PFApiFeedSuccessBlock)success
         failure:(PFApiErrorHandlerBlock)failure;

- (void)majors:(PFApiFeedSuccessBlock)success
       failure:(PFApiErrorHandlerBlock)failure;

- (void)postUserInterests:(NSArray *)firstname
                  success:(PFApiEmptySuccessBlock)success
                  failure:(PFApiErrorHandlerBlock)failure;

- (void)postUserClassification:(NSString *)type
                        school:(NSString *)school
                         major:(NSString *)major
                          year:(NSString *)year
                       success:(PFApiEmptySuccessBlock)success
                       failure:(PFApiErrorHandlerBlock)failure;

- (void)postUserProfile:(NSString *)firstname
               lastname:(NSString *)lastname
               username:(NSString *)username
               location:(NSString *)location
                tagline:(NSString *)tagline
                 gender:(NSString *)gender
              birthdate:(NSDate *)birthdate
                success:(PFApiEmptySuccessBlock)success
                failure:(PFApiErrorHandlerBlock)failure;

- (void)homeFeed:(NSInteger)pageNumber
         success:(PFApiFeedSuccessBlock)success
         failure:(PFApiErrorHandlerBlock)failure;

- (void)categoryFeedById:(NSNumber *)categoryId
              pageNumber:(NSInteger)pageNumber
                 success:(PFApiFeedSuccessBlock)success
                 failure:(PFApiErrorHandlerBlock)failure;

- (void)suggestedUsers:(NSInteger)pageNumber
               success:(PFApiFeedSuccessBlock)success
               failure:(PFApiErrorHandlerBlock)failure;

- (void)userEntriesById:(NSNumber *)userId
             pageNumber:(NSInteger)pageNumber
                success:(PFApiFeedSuccessBlock)success
                failure:(PFApiErrorHandlerBlock)failure;

- (void)userConnectionsById:(NSNumber *)userId
                 pageNumber:(NSInteger)pageNumber
                    success:(PFApiFeedSuccessBlock)success
                    failure:(PFApiErrorHandlerBlock)failure;

- (void)commentsByEntryId:(NSNumber *)entryId
               pageNumber:(NSInteger)pageNumber
                  success:(PFApiFeedSuccessBlock)success
                  failure:(PFApiErrorHandlerBlock)failure;

- (void)entryByEntryId:(NSNumber *)entryId
               success:(PFApiEntrySuccessBlock)success
               failure:(PFApiResponseBlock)failure;

- (void)getThreads:(BOOL)archived
           success:(PFApiFeedSuccessBlock)success
           failure:(PFApiErrorHandlerBlock)failure;

- (void)archiveThread:(NSNumber *)threadId
              success:(PFApiEmptySuccessBlock)success
              failure:(PFApiErrorHandlerBlock)failure;

- (void)postMessage:(NSNumber *)to
            subject:(NSString *)subject
            message:(NSString *)message
            success:(PFApiThreadSuccessBlock)success
            failure:(PFApiErrorHandlerBlock)failure;

- (void)getThread:(NSNumber *)threadId
          success:(PFApiThreadSuccessBlock)success
          failure:(PFApiErrorHandlerBlock)failure;

- (void)getUsersForThread:(NSNumber *)threadId
                  success:(PFApiFeedSuccessBlock)success
                  failure:(PFApiErrorHandlerBlock)failure;

- (void)postThread:(NSNumber *)threadId
           message:(NSString *)message
           success:(PFApiMessageSuccessBlock)success
           failure:(PFApiErrorHandlerBlock)failure;

- (void)notifications:(NSInteger)page
              success:(PFApiFeedSuccessBlock)success
              failure:(PFApiErrorHandlerBlock)failure;

- (void)searchEntries:(NSString *)q
           pageNumber:(NSInteger)page
              success:(PFApiFeedSuccessBlock)success
              failure:(PFApiErrorHandlerBlock)failure;

- (void)searchUsers:(NSString *)q
         pageNumber:(NSInteger)page
            success:(PFApiFeedSuccessBlock)success
            failure:(PFApiErrorHandlerBlock)failure;

- (void)connect:(NSNumber *)userId
        success:(PFApiEmptySuccessBlock)success
        failure:(PFApiErrorHandlerBlock)failure;

- (void)postComment:(NSNumber *)entryId
            comment:(NSString *)comment
            success:(PFApiCommentSuccessBlock)success
            failure:(PFApiErrorHandlerBlock)failure;

- (void)postLike:(NSNumber *)entryId
         success:(PFApiEmptySuccessBlock)success
         failure:(PFApiErrorHandlerBlock)failure;

- (void)postEmailNotification:(NSString *)type
                        value:(NSString *)value
                      success:(PFApiEmptySuccessBlock)success
                      failure:(PFApiErrorHandlerBlock)failure;

- (void)changePassword:(NSString *)password
               confirm:(NSString *)confirm
               success:(PFApiEmptySuccessBlock)success
               failure:(PFApiErrorHandlerBlock)failure;

- (void)changeEmail:(NSString *)email
            success:(PFApiEmptySuccessBlock)success
            failure:(PFApiErrorHandlerBlock)failure;

- (void)forgotPassword:(NSString *)email
               success:(PFApiEmptySuccessBlock)success
               failure:(PFApiErrorHandlerBlock)failure;

- (void)deleteThread:(NSNumber *)threadId
             success:(PFApiEmptySuccessBlock)success
             failure:(PFApiErrorHandlerBlock)failure;

- (void)notificationSeen:(NSNumber *)notificationId
                 success:(PFApiEmptySuccessBlock)success
                 failure:(PFApiErrorHandlerBlock)failure;

- (void)systemSubCategories:(PFApiFeedSuccessBlock)success
                    failure:(PFApiErrorHandlerBlock)failure;

- (void)collaborators:(NSNumber *)userId
              success:(PFApiFeedSuccessBlock)success
              failure:(PFApiErrorHandlerBlock)failure;

- (void)postEntry:(NSString *)type
            title:(NSString *)title
       categoryId:(NSNumber *)categoryId
      description:(NSString *)description
             tags:(NSString *)tags
    collaborators:(NSString *)collaborators
          fileUrl:(NSString *)fileUrl
             file:(NSString *)file
    facebookShare:(BOOL)facebookShare
          success:(PFApiEntrySuccessBlock)success
          failure:(PFApiErrorHandlerBlock)failure;

- (void)uploadAvatar:(NSData *)bytes
                name:(NSString *)name
             success:(PFApiAvatarUploadSuccessBlock)success
             failure:(PFApiErrorHandlerBlock)failure;

- (void)uploadCover:(NSData *)bytes
               name:(NSString *)name
            success:(PFApiCoverUploadSuccessBlock)success
            failure:(PFApiErrorHandlerBlock)failure;

- (void)tagFeed:(NSString *)tag
     pageNumber:(NSInteger)pageNumber
        success:(PFApiFeedSuccessBlock)success
        failure:(PFApiErrorHandlerBlock)failure;

- (void)about:(NSNumber *)userId
      success:(PFApiAboutSuccessBlock)success
      failure:(PFApiErrorHandlerBlock)failure;

- (void)accept:(NSString *)token
       success:(PFApiUserSuccessBlock)success
       failure:(PFApiErrorHandlerBlock)failure;

- (void)categoryById:(NSNumber *)categoryId
             success:(PFApiSystemCategorySuccessBlock)success
             failure:(PFApiErrorHandlerBlock)failure;

- (void)counts:(PFApiCountsSuccessBlock)success
       failure:(PFApiErrorHandlerBlock)failure;

- (void)uploadImage:(NSNumber *)entryId
              bytes:(NSData *)bytes
               name:(NSString *)name
             dfault:(BOOL)dfault
                tag:(NSInteger)tag
           progress:(PFApiProgressBlock)progress
            success:(PFApiMediaUploadSuccessBlock)success
            failure:(PFApiTaggedErrorHandlerBlock)failure;

@end
