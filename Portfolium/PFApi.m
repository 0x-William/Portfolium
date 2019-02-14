//
//  PFApi.m
//  Portfolium
//
//  Created by John Eisberg on 6/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFApi.h"
#import <RestKit/RestKit.h>
#import "RKManagedObjectRequestOperation.h"
#import "HttpStatusCodes.h"
#import "PFSystemCategory.h"
#import "PFImg.h"
#import "PFSchool.h"
#import "PFMajor.h"
#import "PFOnboarding.h"
#import "PFInterests.h"
#import "PFClassification.h"
#import "PFOBEducationVC.h"
#import "PFEntry.h"
#import "PFPagedDatasource.h"
#import "PFProfile.h"
#import "PFComment.h"
#import "PFTag.h"
#import "PFThread.h"
#import "PFAvatar.h"
#import "PFMessage.h"
#import "PFAuthenticationProvider.h"
#import "PFNotification.h"
#import "PFGradient.h"
#import "PFCover.h"
#import "PFStatus.h"
#import "PFCollaborator.h"
#import "PFAbout.h"
#import "PFListCategory.h"
#import "PFAccomplishment.h"
#import "PFAffiliation.h"
#import "PFAthletic.h"
#import "PFAward.h"
#import "PFCertification.h"
#import "PFCourse.h"
#import "PFEducation.h"
#import "PFExperience.h"
#import "PFExtracurricular.h"
#import "PFMilestone.h"
#import "PFPublication.h"
#import "PFSkill.h"
#import "PFVolunteer.h"
#import "PFOrder.h"
#import "PFGoogleAnalytics.h"

NSString *const kPFApiHost = @"apiqa.portfolium.com";
NSString *const kPFApiProtocol = @"https";
NSString *const kPFApiPort = @"80";
NSString *const kPFApiKeyKey = @"X-API-KEY";
NSString *const kPFApiKey = @"B66DED18-DC18-AF2E-D397-9E8C45410A8F";
NSString *const kPFTokenKey = @"X-AUTH-TOKEN";

@implementation PFApi

+ (PFApi *)shared; {
    
    static PFApi *_sharedApi = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        _sharedApi = [[self alloc] init];
        
        //RKLogConfigureByName("RestKit/Network*", RKLogLevelDebug);
        //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
        
        RKLogConfigureByName("RestKit/Network*", RKLogLevelOff);
        RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelOff);
        
        NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", kPFApiProtocol, kPFApiHost]];
        RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
        
        [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:kPFApiKeyKey value:kPFApiKey];
        
        // ---- Error Mapping ----
        
        RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
        
        [errorMapping addPropertyMapping: [RKAttributeMapping attributeMappingFromKeyPath:@"error"
                                                                                toKeyPath:@"errorMessage"]];
        
        RKResponseDescriptor *errorResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                     method:RKRequestMethodPOST
                                                pathPattern:nil
                                                    keyPath:nil
                                                statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
        
        [objectManager addResponseDescriptor:errorResponseDescriptor];
        
        // ---- Me ----
        
        RKObjectMapping *meMapping = [PFUzer getMapping];
        
        RKRelationshipMapping* meTokenRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"auth_token"
                                                    toKeyPath:@"authToken"
                                                  withMapping:[PFToken getMapping]];
        
        RKRelationshipMapping* meProfileRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"profile"
                                                    toKeyPath:@"profile"
                                                  withMapping:[PFProfile getMapping]];
        
        RKRelationshipMapping* meAvatarRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"avatar"
                                                    toKeyPath:@"avatar"
                                                  withMapping:[PFAvatar getMapping]];
        
        RKRelationshipMapping* meCoverRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"cover"
                                                    toKeyPath:@"cover"
                                                  withMapping:[PFCover getMapping]];
        
        [meMapping addPropertyMapping:meTokenRelationShipMapping];
        [meMapping addPropertyMapping:meProfileRelationShipMapping];
        [meMapping addPropertyMapping:meAvatarRelationShipMapping];
        [meMapping addPropertyMapping:meCoverRelationShipMapping];
        
        // ---- Facebook Authentication ----
        
        RKObjectMapping *userMapping = [PFUzer getMapping];
        RKObjectMapping *profileMapping = [PFProfile getMapping];
        
        RKResponseDescriptor *facebookAuthenticationResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:meMapping
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFUzer endPointFacebook]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        RKRelationshipMapping* tokenRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"auth_token"
                                                    toKeyPath:@"authToken"
                                                  withMapping:[PFToken getMapping]];
        
        RKRelationshipMapping* profileRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"profile"
                                                    toKeyPath:@"profile"
                                                  withMapping:profileMapping];
        
        RKRelationshipMapping* avatarRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"avatar"
                                                    toKeyPath:@"avatar"
                                                  withMapping:[PFAvatar getMapping]];
        
        RKRelationshipMapping* coverRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"cover"
                                                    toKeyPath:@"cover"
                                                  withMapping:[PFCover getMapping]];
        
        RKRelationshipMapping* statusRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"status"
                                                    toKeyPath:@"status"
                                                  withMapping:[PFStatus getMapping]];
    
        [userMapping addPropertyMapping:tokenRelationShipMapping];
        [userMapping addPropertyMapping:profileRelationShipMapping];
        [userMapping addPropertyMapping:avatarRelationShipMapping];
        [userMapping addPropertyMapping:coverRelationShipMapping];
        [userMapping addPropertyMapping:statusRelationShipMapping];
        
        [objectManager addResponseDescriptor:facebookAuthenticationResponseDescriptor];
        
        // ---- Twitter Authentication ----
        
        RKResponseDescriptor *twitterAuthenticationResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:meMapping
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFUzer endPointTwitter]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:twitterAuthenticationResponseDescriptor];
        
        // ---- LinkedIn Authentication ----
        
        RKResponseDescriptor *linkedInAuthenticationResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:meMapping
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFUzer endPointLinkedIn]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:linkedInAuthenticationResponseDescriptor];
        
        // ---- Login Authentication ----
        
        RKResponseDescriptor *loginResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:meMapping
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFUzer endPointLogin]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:loginResponseDescriptor];
        
        // ---- Signup Authentication ----
        
        RKResponseDescriptor *signUpResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:meMapping
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFUzer endPointJoin]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:signUpResponseDescriptor];
        
        // ---- User ----
        
        RKResponseDescriptor *userResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:meMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFUzer endPoint]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];

        [objectManager addResponseDescriptor:userResponseDescriptor];
        
        // ---- User With Id ----
        
        RKResponseDescriptor *userWithIdResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFUzer endPointWithId]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:userWithIdResponseDescriptor];
        
        // ---- User Feed ----
        
        RKResponseDescriptor *userFeedWithIdResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFUzer getMapping]
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFUzer endPointFeed]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:userFeedWithIdResponseDescriptor];
        
        // ---- System Categories Feed ----
        
        RKObjectMapping *systemCategoryMapping = [PFSystemCategory getMapping];
        
        RKResponseDescriptor *systemCategoriesFeedWithIdResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:systemCategoryMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFSystemCategory endPointFeed]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        RKRelationshipMapping* gradientRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"gradient"
                                                    toKeyPath:@"gradient"
                                                  withMapping:[PFGradient getMapping]];
        
        [systemCategoryMapping addPropertyMapping:gradientRelationShipMapping];
        
        RKRelationshipMapping* imageRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"image"
                                                    toKeyPath:@"image"
                                                  withMapping:[PFImg getMapping]];
        
        [systemCategoryMapping addPropertyMapping:imageRelationShipMapping];
        
        [objectManager addResponseDescriptor:systemCategoriesFeedWithIdResponseDescriptor];
        
        // ---- School Feed ----
        
        RKResponseDescriptor *highSchoolFeedWithIdResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFSchool getMapping]
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFSchool endPointHighSchool]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:highSchoolFeedWithIdResponseDescriptor];
        
        RKResponseDescriptor *communityCollegeFeedWithIdResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFSchool getMapping]
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFSchool endPointCommunityCollege]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:communityCollegeFeedWithIdResponseDescriptor];
        
        RKResponseDescriptor *collegeFeedWithIdResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFSchool getMapping]
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFSchool endPointCollege]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:collegeFeedWithIdResponseDescriptor];
        
        // ---- Major Feed ----
        
        RKResponseDescriptor *majorFeedWithIdResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFMajor getMapping]
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFMajor endPoint]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:majorFeedWithIdResponseDescriptor];
        
        // ---- Interests ----
        
        RKResponseDescriptor *interestsWithIdResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFInterests getMapping]
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFInterests endPoint]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:interestsWithIdResponseDescriptor];
        
        // ---- Classification ----
        
        RKResponseDescriptor *classificationWithIdResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFClassification getMapping]
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFClassification endPoint]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:classificationWithIdResponseDescriptor];
        
        // ---- Onboarding ----
        
        RKResponseDescriptor *onboardingWithIdResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFOnboarding getMapping]
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFOnboarding endPoint]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:onboardingWithIdResponseDescriptor];
        
        // ---- Profile ----
        
        RKResponseDescriptor *profileResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:profileMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFComment endPoint]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        RKRelationshipMapping* profileAvatarRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"avatar"
                                                    toKeyPath:@"avatar"
                                                  withMapping:[PFAvatar getMapping]];
        
        [profileMapping addPropertyMapping:profileAvatarRelationShipMapping];
        
        RKRelationshipMapping* profileStatusRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"status"
                                                    toKeyPath:@"status"
                                                  withMapping:[PFStatus getMapping]];
        
        [profileMapping addPropertyMapping:profileStatusRelationShipMapping];
        
        [objectManager addResponseDescriptor:profileResponseDescriptor];
        
        // ---- Comment ----
        
        RKObjectMapping *commentMapping = [PFComment getMapping];
        
        RKResponseDescriptor *commentsWithIdResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:commentMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFComment endPoint]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        RKRelationshipMapping* commentProfileRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"profile"
                                                    toKeyPath:@"profile"
                                                  withMapping:profileMapping];
        
        [commentMapping addPropertyMapping:commentProfileRelationShipMapping];
        [objectManager addResponseDescriptor:commentsWithIdResponseDescriptor];
        
        // ---- Media ----
        
        RKObjectMapping *mediaMapping = [PFMedia getMapping];
        
        RKRelationshipMapping* filenameRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"filename"
                                                    toKeyPath:@"filename"
                                                  withMapping:[PFFilename getMapping]];
        
        [mediaMapping addPropertyMapping:filenameRelationShipMapping];
        
        // ---- Entries ----
        
        RKObjectMapping *entryMapping = [PFEntry getMapping];
        
        RKResponseDescriptor *entriesWithIdResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:entryMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFEntry endPoint]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        RKRelationshipMapping* entryProfileRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"profile"
                                                    toKeyPath:@"profile"
                                                  withMapping:profileMapping];
        
        [entryMapping addPropertyMapping:entryProfileRelationShipMapping];
        
        RKRelationshipMapping* entryCommentsRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"comment_list"
                                                    toKeyPath:@"comments"
                                                  withMapping:commentMapping];
        
        [entryMapping addPropertyMapping:entryCommentsRelationShipMapping];
        
        RKRelationshipMapping* entryTagsRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"tags"
                                                    toKeyPath:@"tags"
                                                  withMapping:[PFTag getMapping]];
        
        [entryMapping addPropertyMapping:entryTagsRelationShipMapping];
        
        RKRelationshipMapping* mediaRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"media"
                                                    toKeyPath:@"media"
                                                  withMapping:mediaMapping];
        
        [entryMapping addPropertyMapping:mediaRelationShipMapping];
        
        RKRelationshipMapping* likersRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"likers"
                                                    toKeyPath:@"likers"
                                                  withMapping:profileMapping];
        
        [entryMapping addPropertyMapping:likersRelationShipMapping];
        
        RKRelationshipMapping* collaboratorsRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"collaborators"
                                                    toKeyPath:@"collaborators"
                                                  withMapping:profileMapping];
        
        [entryMapping addPropertyMapping:collaboratorsRelationShipMapping];
        
        RKRelationshipMapping* entryStatusRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"status"
                                                    toKeyPath:@"status"
                                                  withMapping:[PFStatus getMapping]];
        
        [entryMapping addPropertyMapping:entryStatusRelationShipMapping];
        
        [objectManager addResponseDescriptor:entriesWithIdResponseDescriptor];
        
        // ---- Entries with Category Id ----
        
        RKResponseDescriptor *entriesWithCategoryIdResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:entryMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFEntry endPointWithCategoryId]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:entriesWithCategoryIdResponseDescriptor];
        
        // ---- Entries with User Id ----
        
        RKResponseDescriptor *entriesWithUserIdResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:entryMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFEntry endPointWithUserId]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:entriesWithUserIdResponseDescriptor];
        
        // ---- Suggested Users ----
        
        RKResponseDescriptor *suggestedUsersResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:profileMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFUzer endPointSuggested]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:suggestedUsersResponseDescriptor];
        
        // ---- Connected Users ----
        
        RKResponseDescriptor *connectionsUsersResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:profileMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFUzer endPointConnections]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:connectionsUsersResponseDescriptor];
        
        // ---- Comments with Entry Id ----
        
        RKResponseDescriptor *commentsWithEntryIdResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:commentMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFComment endPointWithEntryId]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:commentsWithEntryIdResponseDescriptor];
        
        // ---- Entry with Entry Id ----
        
        RKResponseDescriptor *entryWithEntryIdResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:entryMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFEntry endPointWithEntryId]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:entryWithEntryIdResponseDescriptor];
        
        // ---- Messages ----
        
        RKObjectMapping *messageMapping = [PFMessage getMapping];
        
        RKResponseDescriptor *messageResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:messageMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFThread endPoint]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        RKRelationshipMapping* messageProfileRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"profile"
                                                    toKeyPath:@"profile"
                                                  withMapping:profileMapping];
        
        [messageMapping addPropertyMapping:messageProfileRelationShipMapping];
        [objectManager addResponseDescriptor:messageResponseDescriptor];
        
        // ---- Threads ----
        
        RKObjectMapping *threadMapping = [PFThread getMapping];
        
        RKResponseDescriptor *threadsResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:threadMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFThread endPoint]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        RKRelationshipMapping* threadProfileRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"profile"
                                                    toKeyPath:@"profile"
                                                  withMapping:profileMapping];
        
        [threadMapping addPropertyMapping:threadProfileRelationShipMapping];
        
        RKRelationshipMapping* threadMessageRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"messages"
                                                    toKeyPath:@"messages"
                                                  withMapping:messageMapping];
        
        [threadMapping addPropertyMapping:threadMessageRelationShipMapping];
        [objectManager addResponseDescriptor:threadsResponseDescriptor];
        
        // ---- Archive Threads ----
        
        RKResponseDescriptor *archiveThreadsResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:threadMapping
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFThread endPointWithThreadId]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:archiveThreadsResponseDescriptor];
        
        // ---- Create Thread/Message ----
        
        RKResponseDescriptor *createThreadsResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:threadMapping
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFThread createEndPoint]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:createThreadsResponseDescriptor];
        
        // ---- Thread Messages ----
        
        RKResponseDescriptor *threadMessagesResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:threadMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFThread endPointForMessages]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:threadMessagesResponseDescriptor];
        
        // ---- Thread Users ----
        
        RKResponseDescriptor *threadUsersResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:profileMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFThread endPointForUsers]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:threadUsersResponseDescriptor];
        
        // ---- Thread Post ----
        
        RKResponseDescriptor *threadPostResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:messageMapping
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFThread endPointForReply]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:threadPostResponseDescriptor];
        
        // ---- Entry Search ----
        
        RKResponseDescriptor *entrySearchResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:entryMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFEntry endPointSearch]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:entrySearchResponseDescriptor];
        
        // ---- User Search ----
        
        RKResponseDescriptor *userSearchResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:profileMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFProfile endPointSearch]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:userSearchResponseDescriptor];
        
        // ---- User Connect ----
        
        RKResponseDescriptor *userConnectResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFUzer endPointConnect]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:userConnectResponseDescriptor];
        
        // ---- Post Comment ----
        
        RKResponseDescriptor *postCommentResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:commentMapping
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFComment endPointCreateWithEntryId]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:postCommentResponseDescriptor];
        
        // ---- Like Entry ----
        
        RKResponseDescriptor *likeEntryResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:entryMapping
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFEntry endPointLikeWithEntryId]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:likeEntryResponseDescriptor];
        
        // ---- Notifications ----
        
        RKObjectMapping *notificationMapping = [PFNotification getMapping];
        
        RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
        
        [dynamicMapping setObjectMappingForRepresentationBlock:^RKObjectMapping *(id representation) {
            
            if ([[representation valueForKey:@"dynamic_type"]
                 isEqualToString:@"user"]) {
                
                return userMapping;
                
            } else if([[representation valueForKey:@"dynamic_type"]
                       isEqualToString:@"entry"]) {
                
                return entryMapping;
            }
            
            return nil;
        }];
        
        [notificationMapping addPropertyMapping:[RKRelationshipMapping
                                                 relationshipMappingFromKeyPath:@"object"
                                                 toKeyPath:@"user"
                                                 withMapping:dynamicMapping]];
        
        [notificationMapping addPropertyMapping:[RKRelationshipMapping
                                                 relationshipMappingFromKeyPath:@"object"
                                                 toKeyPath:@"entry"
                                                 withMapping:dynamicMapping]];
        
        RKResponseDescriptor *notificationsResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:notificationMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFNotification endPoint]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:notificationsResponseDescriptor];
        
        // ---- Email Notifications ----
        
        RKResponseDescriptor *emailNotificationsResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFUzer getMapping]
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFUzer endPointEmailNotification]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:emailNotificationsResponseDescriptor];
        
        // ---- Change Password ----
        
        RKResponseDescriptor *changePasswordResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFUzer getMapping]
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFUzer endPointChangePassword]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:changePasswordResponseDescriptor];
        
        // ---- Change Email ----
        
        RKResponseDescriptor *changeEmailResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFUzer getMapping]
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFUzer endPointChangeEmail]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:changeEmailResponseDescriptor];
        
        // ---- Forgot Password ----
        
        RKResponseDescriptor *forgotPasswordResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFUzer getMapping]
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFUzer endPointForgotPassword]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:forgotPasswordResponseDescriptor];
        
        // ---- Thread delete ----
        
        RKResponseDescriptor *threadDeleteResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFThread getMapping]
                                                     method:RKRequestMethodDELETE
                                                pathPattern:[PFThread endPointForMessages]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:threadDeleteResponseDescriptor];
        
        // ---- Notification seen ----
        
        RKResponseDescriptor *notificationSeenResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFNotification getMapping]
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFNotification endPointSeen]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:notificationSeenResponseDescriptor];
        
        // ---- Collaborators ----
        
        RKResponseDescriptor *collaboratorsResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFCollaborator getMapping]
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFCollaborator endPointUser]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:collaboratorsResponseDescriptor];
        
        // ---- Post Entry ----
        
        RKResponseDescriptor *postEntryResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:entryMapping
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFEntry endPointCreate]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:postEntryResponseDescriptor];
        
        // ---- Avatar ----
        
        RKResponseDescriptor *postAvatarResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFAvatar getMapping]
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFAvatar endPointCreate]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:postAvatarResponseDescriptor];
        
        // ---- Cover ----
        
        RKResponseDescriptor *postCoverResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFCover getMapping]
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFCover endPointCreate]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:postCoverResponseDescriptor];
        
        // ---- Tag Feed ----
        
        RKResponseDescriptor *tagFeedResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:entryMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFEntry endPointWithTag]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:tagFeedResponseDescriptor];
        
        // ---- About ----
        
        RKObjectMapping *aboutMapping = [PFAbout getMapping];
        
        RKResponseDescriptor *aboutResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:aboutMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFAbout endPointWithUserId]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        RKRelationshipMapping* orderRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"order"
                                                    toKeyPath:@"order"
                                                  withMapping:[PFOrder getMapping]];
        
        RKRelationshipMapping* aboutInterestsRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"interests"
                                                    toKeyPath:@"interests"
                                                  withMapping:[PFListCategory getMapping]];
        
        RKRelationshipMapping* aboutAccomplishmentsRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"accomplishments"
                                                    toKeyPath:@"accomplishments"
                                                  withMapping:[PFAccomplishment getMapping]];
        
        RKRelationshipMapping* aboutAffiliationsRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"affiliations"
                                                    toKeyPath:@"affiliations"
                                                  withMapping:[PFAccomplishment getMapping]];
        
        RKRelationshipMapping* aboutAthleticsRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"athletics"
                                                    toKeyPath:@"athletics"
                                                  withMapping:[PFAthletic getMapping]];
        
        RKRelationshipMapping* aboutAwardsRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"awards"
                                                    toKeyPath:@"awards"
                                                  withMapping:[PFAward getMapping]];
        
        RKRelationshipMapping* aboutCertificationsRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"certifications"
                                                    toKeyPath:@"certifications"
                                                  withMapping:[PFAward getMapping]];
        
        RKRelationshipMapping* aboutCoursesRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"courses"
                                                    toKeyPath:@"courses"
                                                  withMapping:[PFCourse getMapping]];
        
        RKRelationshipMapping* aboutEducationsRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"educations"
                                                    toKeyPath:@"educations"
                                                  withMapping:[PFEducation getMapping]];
        
        RKRelationshipMapping* aboutExperiencesRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"experiences"
                                                    toKeyPath:@"experiences"
                                                  withMapping:[PFExperience getMapping]];
        
        RKRelationshipMapping* aboutExtracurricularsRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"extracurriculars"
                                                    toKeyPath:@"extracurriculars"
                                                  withMapping:[PFExtracurricular getMapping]];
        
        RKRelationshipMapping* aboutMilestonesRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"milestones"
                                                    toKeyPath:@"milestones"
                                                  withMapping:[PFMilestone getMapping]];
        
        RKRelationshipMapping* aboutPublicationsRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"publications"
                                                    toKeyPath:@"publications"
                                                  withMapping:[PFPublication getMapping]];
        
        RKRelationshipMapping* aboutSkillsRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"skills"
                                                    toKeyPath:@"skills"
                                                  withMapping:[PFSkill getMapping]];
        
        RKRelationshipMapping* aboutVolunteersRelationShipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"volunteers"
                                                    toKeyPath:@"volunteers"
                                                  withMapping:[PFVolunteer getMapping]];
        
        [aboutMapping addPropertyMapping:orderRelationShipMapping];
        [aboutMapping addPropertyMapping:aboutInterestsRelationShipMapping];
        [aboutMapping addPropertyMapping:aboutAccomplishmentsRelationShipMapping];
        [aboutMapping addPropertyMapping:aboutAffiliationsRelationShipMapping];
        [aboutMapping addPropertyMapping:aboutAthleticsRelationShipMapping];
        [aboutMapping addPropertyMapping:aboutAwardsRelationShipMapping];
        [aboutMapping addPropertyMapping:aboutCertificationsRelationShipMapping];
        [aboutMapping addPropertyMapping:aboutCoursesRelationShipMapping];
        [aboutMapping addPropertyMapping:aboutEducationsRelationShipMapping];
        [aboutMapping addPropertyMapping:aboutExperiencesRelationShipMapping];
        [aboutMapping addPropertyMapping:aboutExtracurricularsRelationShipMapping];
        [aboutMapping addPropertyMapping:aboutMilestonesRelationShipMapping];
        [aboutMapping addPropertyMapping:aboutPublicationsRelationShipMapping];
        [aboutMapping addPropertyMapping:aboutSkillsRelationShipMapping];
        [aboutMapping addPropertyMapping:aboutVolunteersRelationShipMapping];
        
        [objectManager addResponseDescriptor:aboutResponseDescriptor];
        
        // ---- Connection Accept ----
        
        RKResponseDescriptor *connectionAcceptResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFUzer endPointConnectionAccept]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:connectionAcceptResponseDescriptor];
        
        // ---- Category by Id ----
        
        RKResponseDescriptor *categoryByIdAcceptResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:systemCategoryMapping
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFSystemCategory endPointWithCategoryId]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:categoryByIdAcceptResponseDescriptor];
        
        // ---- Counts ----
        
        RKResponseDescriptor *countsResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFCount getMapping]
                                                     method:RKRequestMethodGET
                                                pathPattern:[PFCount endPoint]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:countsResponseDescriptor];
        
        // ---- Image ----
        
        RKResponseDescriptor *postImageResponseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:[PFMedia getMapping]
                                                     method:RKRequestMethodPOST
                                                pathPattern:[PFMedia endPointWithId]
                                                    keyPath:nil
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:postImageResponseDescriptor];

    });
    
    return _sharedApi;
}

- (void)setAuthenticated:(NSString *)token; {
    
    [[[RKObjectManager sharedManager] HTTPClient]
     setDefaultHeader:kPFTokenKey value:token];
}

- (void)setUnauthenticated; {
    
    [[[RKObjectManager sharedManager] HTTPClient]
     setDefaultHeader:kPFTokenKey value:@""];
}

- (void)getTokenWithFacebook:(NSString *)token
                    referral:(NSString *)referral
                     success:(PFApiUserSuccessBlock)success
                     failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[PFUzer endPointFacebook]
                                     parameters:@{ @"token" : token,
                                                   @"referral" : referral,
                                                   kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            PFUzer *user = [[mappingResult array] objectAtIndex:0];
                                            success(user);
                                        }
                                        failure:^(RKObjectRequestOperation *operation,
                                                  NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)getTokenWithTwitter:(NSString *)token
                     secret:(NSString *)secret
                   referral:(NSString *)referral
                    success:(PFApiUserSuccessBlock)success
                    failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[PFUzer endPointTwitter]
                                     parameters:@{ @"token" : token,
                                                   @"secret" : secret,
                                                   @"referral" : referral,
                                                   kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            PFUzer *user = [[mappingResult array] objectAtIndex:0];
                                            success(user);
                                        }
                                        failure:^(RKObjectRequestOperation *operation,
                                                  NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)getTokenWithLinkedIn:(NSString *)token
                    referral:(NSString *)referral
                     success:(PFApiUserSuccessBlock)success
                     failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[PFUzer endPointLinkedIn]
                                     parameters:@{ @"token" : token,
                                                   @"secret" : token,
                                                   @"referral" : referral,
                                                   kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            PFUzer *user = [[mappingResult array] objectAtIndex:0];
                                            success(user);
                                        }
                                        failure:^(RKObjectRequestOperation *operation,
                                                  NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)signUp:(NSString *)email
      username:(NSString *)username
     firstname:(NSString *)firstname
      lastname:(NSString *)lastname
      password:(NSString *)password
      referral:(NSString *)referral
       success:(PFApiUserSuccessBlock)success
       failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[PFUzer endPointJoin]
                                     parameters:@{ @"email" : email,
                                                   @"username" : username,
                                                   @"firstname" : firstname,
                                                   @"lastname" : lastname,
                                                   @"password" : password,
                                                   @"referral" : referral,
                                                   kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            PFUzer *user = [[mappingResult array] objectAtIndex:0];
                                            success(user);
                                        } failure:^(RKObjectRequestOperation *operation,
                                                  NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)login:(NSString *)identity
     password:(NSString *)password
      success:(PFApiUserSuccessBlock)success
      failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[PFUzer endPointLogin]
                                     parameters:@{ @"identity" : identity,
                                                   @"password" : password,
                                                   kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            PFUzer *user = [[mappingResult array] objectAtIndex:0];
                                            success(user);
                                        } failure:^(RKObjectRequestOperation *operation,
                                                  NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)me:(PFApiUserSuccessBlock)success
   failure:(PFApiErrorHandlerBlock)failure; {
    
    PFUzer *user = [[PFUzer alloc] init];
    
    [[RKObjectManager sharedManager] getObject:user
                                          path:[PFUzer endPoint]
                                    parameters:@{ kPFApiKeyKey : kPFApiKey }
                                       success:^(RKObjectRequestOperation *operation,
                                                 RKMappingResult *mappingResult) {
                                           success(user);
                                       } failure:^(RKObjectRequestOperation *operation,
                                                   NSError *error) {
                                           [self onError:operation
                                                   error:error
                                                 failure:failure];
                                       }];
}

- (void)getUserWithId:(NSNumber *)userId
              success:(PFApiUserSuccessBlock)success
              failure:(PFApiResponseBlock)failure; {
    
    PFUzer *user = [[PFUzer alloc] init];
    [user setUserId:userId];
    
    [[RKObjectManager sharedManager] getObject:user
                                          path:[user endPointWithIdPath]
                                    parameters:@{ kPFApiKeyKey : kPFApiKey }
                                       success:^(RKObjectRequestOperation *operation,
                                                 RKMappingResult *mappingResult) {
                                           success(user);
                                       } failure:^(RKObjectRequestOperation *operation,
                                                   NSError *error) {
                                           failure(error, operation.HTTPRequestOperation.response.statusCode);
                                           /*
                                           [self onError:operation
                                                   error:error
                                                 failure:failure];
                                            */
                                       }];
}

- (void)linkUserWithDomain:(NSString *)domain
                     token:(NSString *)token
                    secret:(NSString *)secret
                   success:(PFApiUserSuccessBlock)success
                   failure:(PFApiErrorHandlerBlock)failure; {
    
    NSString *path = [NSString stringWithFormat:@"social/%@", domain];
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:path
                                     parameters:@{ @"token" : token,
                                                   @"secret" : secret,
                                                   kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            PFUzer *user = [[mappingResult array] objectAtIndex:0];
                                            success(user);
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)users:(NSInteger)page
      success:(PFApiFeedSuccessBlock)success
      failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[PFUzer endPointFeed]
                                           parameters:@{ @"limit" : [NSNumber numberWithInt:16],
                                                         @"offset" : [NSNumber numberWithInt:((int)page * 16)],
                                                         kPFApiKeyKey : kPFApiKey }
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)systemCategories:(PFApiFeedSuccessBlock)success
                 failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[PFSystemCategory endPointFeed]
                                           parameters:@{ kPFApiKeyKey : kPFApiKey }
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)highSchools:(PFApiFeedSuccessBlock)success
            failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[PFSchool endPointHighSchool]
                                           parameters:@{ kPFApiKeyKey : kPFApiKey }
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)communityColleges:(PFApiFeedSuccessBlock)success
                  failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[PFSchool endPointCommunityCollege]
                                           parameters:@{ kPFApiKeyKey : kPFApiKey }
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)colleges:(PFApiFeedSuccessBlock)success
         failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[PFSchool endPointCollege]
                                           parameters:@{ kPFApiKeyKey : kPFApiKey }
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)majors:(PFApiFeedSuccessBlock)success
       failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[PFMajor endPoint]
                                           parameters:@{ kPFApiKeyKey : kPFApiKey }
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)postUserInterests:(NSArray *)categoryIds
                  success:(PFApiEmptySuccessBlock)success
                  failure:(PFApiErrorHandlerBlock)failure; {
    
    PFInterests *interests = [[PFInterests alloc] init];
    [interests setCategoryIds:categoryIds];
    
    NSMutableDictionary *parameters = [interests categoryIdsToDictionary];
    [parameters setObject:kPFApiKey forKey:kPFApiKeyKey];
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[PFInterests endPoint]
                                     parameters:parameters
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            success();
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)postUserClassification:(NSString *)type
                        school:(NSString *)school
                         major:(NSString *)major
                          year:(NSString *)year
                       success:(PFApiEmptySuccessBlock)success
                       failure:(PFApiErrorHandlerBlock)failure; {
    
    NSMutableDictionary *parameters = [[PFOnboarding shared] buildEducationParameters];
    [parameters setObject:kPFApiKey forKey:kPFApiKeyKey];
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[PFClassification endPoint]
                                     parameters:parameters
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            success();
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)postUserProfile:(NSString *)firstname
               lastname:(NSString *)lastname
               username:(NSString *)username
               location:(NSString *)location
                tagline:(NSString *)tagline
                 gender:(NSString *)gender
              birthdate:(NSDate *)birthdate
                success:(PFApiEmptySuccessBlock)success
                failure:(PFApiErrorHandlerBlock)failure; {
    
    NSMutableDictionary *parameters = [[PFOnboarding shared] buildBasicsParameters];
    [parameters setObject:kPFApiKey forKey:kPFApiKeyKey];
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[PFOnboarding endPoint]
                                     parameters:parameters
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            success();
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)homeFeed:(NSInteger)pageNumber
         success:(PFApiFeedSuccessBlock)success
         failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[PFEntry endPoint]
                                           parameters:@{ @"limit" : [NSNumber numberWithInt:kDefaultPageSize],
                                                         @"offset" : [NSNumber numberWithInt:
                                                                      (int)pageNumber * (int)kDefaultPageSize],
                                                         kPFApiKeyKey : kPFApiKey}
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)categoryFeedById:(NSNumber *)categoryId
              pageNumber:(NSInteger)pageNumber
                 success:(PFApiFeedSuccessBlock)success
                 failure:(PFApiErrorHandlerBlock)failure; {
    
    PFEntry *entry = [[PFEntry alloc] init];
    [entry setCategoryId:categoryId];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[entry endPointWithCategoryIdPath]
                                           parameters:@{ @"limit" : [NSNumber numberWithInt:kDefaultPageSize],
                                                         @"offset" : [NSNumber numberWithInt:
                                                                      (int)pageNumber * (int)kDefaultPageSize],
                                                         kPFApiKeyKey : kPFApiKey}
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)suggestedUsers:(NSInteger)pageNumber
               success:(PFApiFeedSuccessBlock)success
               failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[PFUzer endPointSuggested]
                                           parameters:@{ @"limit" : [NSNumber numberWithInt:kDefaultPageSize],
                                                         @"offset" : [NSNumber numberWithInt:
                                                                      (int)pageNumber * (int)kDefaultPageSize],
                                                         kPFApiKeyKey : kPFApiKey}
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)userEntriesById:(NSNumber *)userId
             pageNumber:(NSInteger)pageNumber
                success:(PFApiFeedSuccessBlock)success
                failure:(PFApiErrorHandlerBlock)failure; {
    
    PFEntry *entry = [[PFEntry alloc] init];
    [entry setUserId:userId];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[entry endPointWithUserIdPath]
                                           parameters:@{ @"limit" : [NSNumber numberWithInt:kDefaultPageSize],
                                                         @"offset": [NSNumber numberWithInt: (int)pageNumber * (int)kDefaultPageSize],
                                                         @"sort" : @"order",
                                                         kPFApiKeyKey : kPFApiKey}
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)userConnectionsById:(NSNumber *)userId
                 pageNumber:(NSInteger)pageNumber
                    success:(PFApiFeedSuccessBlock)success
                    failure:(PFApiErrorHandlerBlock)failure; {
    
    PFUzer *user = [[PFUzer alloc] init];
    [user setUserId:userId];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[user endPointConnectionsPath]
                                           parameters:@{ @"limit" : [NSNumber numberWithInt:kDefaultPageSize],
                                                         @"offset" : [NSNumber numberWithInt:
                                                                      (int)pageNumber * (int)kDefaultPageSize],
                                                         kPFApiKeyKey : kPFApiKey}
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)commentsByEntryId:(NSNumber *)entryId
               pageNumber:(NSInteger)pageNumber
                  success:(PFApiFeedSuccessBlock)success
                  failure:(PFApiErrorHandlerBlock)failure; {
    
    PFComment *comment = [[PFComment alloc] init];
    [comment setEntryId:entryId];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[comment endPointWithEntryIdPath]
                                           parameters:@{ @"limit" : [NSNumber numberWithInt:kDefaultPageSize],
                                                         @"offset" : [NSNumber numberWithInt:
                                                                      (int)pageNumber * (int)kDefaultPageSize],
                                                         kPFApiKeyKey : kPFApiKey}
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)entryByEntryId:(NSNumber *)entryId
               success:(PFApiEntrySuccessBlock)success
               failure:(PFApiResponseBlock)failure; {
    
    PFEntry *entry = [[PFEntry alloc] init];
    [entry setEntryId:entryId];
    
    [[RKObjectManager sharedManager] getObject:entry
                                          path:[entry endPointWithEntryIdPath]
                                    parameters:@{ kPFApiKeyKey : kPFApiKey }
                                       success:^(RKObjectRequestOperation *operation,
                                                 RKMappingResult *mappingResult) {
                                           success(entry);
                                       } failure:^(RKObjectRequestOperation *operation,
                                                   NSError *error) {
                                           failure(error, operation.HTTPRequestOperation.response.statusCode);
                                           /*
                                           [self onError:operation
                                                   error:error
                                                 failure:failure];
                                            */
                                       }];
}

- (void)getThreads:(BOOL)archived
           success:(PFApiFeedSuccessBlock)success
           failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[PFThread endPoint]
                                           parameters:@{ @"archived" : archived ? @"true" : @"false",
                                                         kPFApiKeyKey : kPFApiKey }
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)archiveThread:(NSNumber *)threadId
              success:(PFApiEmptySuccessBlock)success
              failure:(PFApiErrorHandlerBlock)failure; {
    
    PFThread *thread = [[PFThread alloc] init];
    [thread setThreadId:threadId];
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[thread pathWithThreadId]
                                     parameters:@{ kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            success();
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)postMessage:(NSNumber *)to
            subject:(NSString *)subject
            message:(NSString *)message
            success:(PFApiThreadSuccessBlock)success
            failure:(PFApiErrorHandlerBlock)failure; {
    
    PFThread *thread = [[PFThread alloc] init];
    
    [[RKObjectManager sharedManager] postObject:thread
                                           path:[PFThread createEndPoint]
                                     parameters:@{ @"to_user_ids" : to,
                                                   @"subject" : subject,
                                                   @"message" : message,
                                                   kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            success(thread);
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)getThread:(NSNumber *)threadId
          success:(PFApiThreadSuccessBlock)success
          failure:(PFApiErrorHandlerBlock)failure; {
    
    PFThread *thread = [[PFThread alloc] init];
    [thread setThreadId:threadId];
    
    [[RKObjectManager sharedManager] getObject:thread
                                          path:[thread messagesWithThreadId]
                                    parameters:@{ kPFApiKeyKey : kPFApiKey }
                                       success:^(RKObjectRequestOperation *operation,
                                                 RKMappingResult *mappingResult) {
                                           success(thread);
                                       }
                                       failure:^(RKObjectRequestOperation *operation,
                                                 NSError *error) {
                                           [self onError:operation
                                                   error:error
                                                 failure:failure];
                                       }];
}

- (void)getUsersForThread:(NSNumber *)threadId
                  success:(PFApiFeedSuccessBlock)success
                  failure:(PFApiErrorHandlerBlock)failure; {
    
    PFThread *thread = [[PFThread alloc] init];
    [thread setThreadId:threadId];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[thread usersWithThreadId]
                                           parameters:@{ kPFApiKeyKey : kPFApiKey }
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)postThread:(NSNumber *)threadId
           message:(NSString *)message
           success:(PFApiMessageSuccessBlock)success
           failure:(PFApiErrorHandlerBlock)failure; {
    
    PFThread *thread = [[PFThread alloc] init];
    [thread setThreadId:threadId];
    
    PFMessage *retMessage = [[PFMessage alloc] init];
    
    [[RKObjectManager sharedManager] postObject:retMessage
                                           path:[thread replyWithThreadId]
                                     parameters:@{ @"message" : message,
                                                   kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            success(retMessage);
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)notifications:(NSInteger)page
              success:(PFApiFeedSuccessBlock)success
              failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[PFNotification endPoint]
                                           parameters:@{ @"limit" : [NSNumber numberWithInt:16],
                                                         @"offset" : [NSNumber numberWithInt:((int)page * 16)],
                                                         kPFApiKeyKey : kPFApiKey }
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)searchEntries:(NSString *)q
           pageNumber:(NSInteger)page
              success:(PFApiFeedSuccessBlock)success
              failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[PFEntry endPointSearch]
                                           parameters:@{ @"q" : q,
                                                         @"limit" : [NSNumber numberWithInt:16],
                                                         @"offset" : [NSNumber numberWithInt:((int)page * 16)],
                                                         kPFApiKeyKey : kPFApiKey }
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)searchUsers:(NSString *)q
         pageNumber:(NSInteger)page
            success:(PFApiFeedSuccessBlock)success
            failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[PFProfile endPointSearch]
                                           parameters:@{ @"q" : q,
                                                         @"limit" : [NSNumber numberWithInt:16],
                                                         @"offset" : [NSNumber numberWithInt:((int)page * 16)],
                                                         kPFApiKeyKey : kPFApiKey }
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)connect:(NSNumber *)userId
        success:(PFApiEmptySuccessBlock)success
        failure:(PFApiErrorHandlerBlock)failure; {
    
    PFUzer *user = [[PFUzer alloc] init];
    [user setUserId:userId];
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[user endPointConnectPath]
                                     parameters:@{ kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            
                                            [[PFGoogleAnalytics shared] requestedToConnect];
                                            
                                            success();
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)postComment:(NSNumber *)entryId
            comment:(NSString *)body
            success:(PFApiCommentSuccessBlock)success
            failure:(PFApiErrorHandlerBlock)failure; {
    
    PFComment *comment = [[PFComment alloc] init];
    [comment setEntryId:entryId];
    
    [[RKObjectManager sharedManager] postObject:comment
                                           path:[comment endPointCreateWithEntryIdPath]
                                     parameters:@{ @"comment" : body,
                                                   kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            success(comment);
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)postLike:(NSNumber *)entryId
         success:(PFApiEmptySuccessBlock)success
         failure:(PFApiErrorHandlerBlock)failure; {
    
    PFEntry *entry = [[PFEntry alloc] init];
    [entry setEntryId:entryId];
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[entry endPointLikeWithEntryIdPath]
                                     parameters:@{ kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            success();
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)postEmailNotification:(NSString *)type
                        value:(NSString *)value
                      success:(PFApiEmptySuccessBlock)success
                      failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[PFUzer endPointEmailNotification]
                                     parameters:@{ @"type" : type,
                                                   @"value" : value,
                                                   kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            success();
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)changePassword:(NSString *)password
               confirm:(NSString *)confirm
               success:(PFApiEmptySuccessBlock)success
               failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[PFUzer endPointChangePassword]
                                     parameters:@{ @"password" : password,
                                                   @"confirm" : confirm,
                                                   kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            success();
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)changeEmail:(NSString *)email
            success:(PFApiEmptySuccessBlock)success
            failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[PFUzer endPointChangeEmail]
                                     parameters:@{ @"email" : email,
                                                   kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            success();
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)forgotPassword:(NSString *)email
               success:(PFApiEmptySuccessBlock)success
               failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[PFUzer endPointForgotPassword]
                                     parameters:@{ @"email" : email,
                                                   kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            success();
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)deleteThread:(NSNumber *)threadId
             success:(PFApiEmptySuccessBlock)success
             failure:(PFApiErrorHandlerBlock)failure; {
    
    PFThread *thread = [[PFThread alloc] init];
    [thread setThreadId:threadId];
    
    [[RKObjectManager sharedManager] deleteObject:nil
                                             path:[thread messagesWithThreadId]
                                       parameters:@{ kPFApiKeyKey : kPFApiKey }
                                          success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                              success();
                                          } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                              [self onError:operation
                                                      error:error
                                                    failure:failure];
                                          }];
}

- (void)notificationSeen:(NSNumber *)notificationId
                 success:(PFApiEmptySuccessBlock)success
                 failure:(PFApiErrorHandlerBlock)failure; {
    
    PFNotification *notification = [[PFNotification alloc] init];
    [notification setNotificationId:notificationId];
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[notification endPointSeenPath]
                                     parameters:@{ kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            success();
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)systemSubCategories:(PFApiFeedSuccessBlock)success
                    failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[PFSystemCategory endPointFeed]
                                           parameters:@{ kPFApiKeyKey : kPFApiKey,
                                                         @"type" : @"children" }
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)collaborators:(NSNumber *)userId
              success:(PFApiFeedSuccessBlock)success
              failure:(PFApiErrorHandlerBlock)failure; {
    
    PFCollaborator *collaborator = [[PFCollaborator alloc] init];
    [collaborator setCollaboratorId:userId];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[collaborator endPointUserPath]
                                           parameters:@{ kPFApiKeyKey : kPFApiKey }
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

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
          failure:(PFApiErrorHandlerBlock)failure; {
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[PFEntry endPointCreate]
                                     parameters:@{ @"type" : type,
                                                   @"title" : title,
                                                   @"category_id" : categoryId,
                                                   @"description" : description,
                                                   @"tags" : tags,
                                                   @"collaborators" : collaborators,
                                                   @"fileUrl" : fileUrl,
                                                   @"file" : file,
                                                   kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            PFEntry *entry = [[mappingResult array] objectAtIndex:0];
                                            success(entry);
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)uploadAvatar:(NSData *)bytes
                name:(NSString *)name
             success:(PFApiAvatarUploadSuccessBlock)success
             failure:(PFApiErrorHandlerBlock)failure; {
    
    NSMutableURLRequest *request = [[RKObjectManager sharedManager]
                                    multipartFormRequestWithObject:nil
                                    method:RKRequestMethodPOST
                                    path:[PFAvatar endPointCreate]
                                    parameters:@{ kPFApiKeyKey : kPFApiKey }
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        
                                        [formData appendPartWithFileData:bytes
                                                                    name:@"file"
                                                                fileName:@"photo.jpeg"
                                                                mimeType:@"image/jpeg"];
                                    }];
    
    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager]
                                           objectRequestOperationWithRequest:request
                                           success:^(RKObjectRequestOperation *operation,
                                                     RKMappingResult *mappingResult) {
                                               PFAvatar *avatar = [[mappingResult array] objectAtIndex:0];
                                               success(avatar);
                                           } failure:^(RKObjectRequestOperation *operation,
                                                       NSError *error) {
                                               [self onError:operation
                                                       error:error
                                                     failure:failure];
                                           }];
    
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

- (void)uploadCover:(NSData *)bytes
               name:(NSString *)name
            success:(PFApiCoverUploadSuccessBlock)success
            failure:(PFApiErrorHandlerBlock)failure; {
    
    NSMutableURLRequest *request = [[RKObjectManager sharedManager]
                                    multipartFormRequestWithObject:nil
                                    method:RKRequestMethodPOST
                                    path:[PFCover endPointCreate]
                                    parameters:@{ kPFApiKeyKey : kPFApiKey }
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        
                                        [formData appendPartWithFileData:bytes
                                                                    name:@"file"
                                                                fileName:@"photo.jpeg"
                                                                mimeType:@"image/jpeg"];
                                    }];
    
    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager]
                                           objectRequestOperationWithRequest:request
                                           success:^(RKObjectRequestOperation *operation,
                                                     RKMappingResult *mappingResult) {
                                               PFCover *cover = [[mappingResult array] objectAtIndex:0];
                                               success(cover);
                                           } failure:^(RKObjectRequestOperation *operation,
                                                       NSError *error) {
                                               [self onError:operation
                                                       error:error
                                                     failure:failure];
                                           }];
    
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

- (void)tagFeed:(NSString *)tag
     pageNumber:(NSInteger)pageNumber
        success:(PFApiFeedSuccessBlock)success
        failure:(PFApiErrorHandlerBlock)failure; {
    
    PFEntry *entry = [[PFEntry alloc] init];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:[entry endPointWithTag:tag]
                                           parameters:@{ @"limit" : [NSNumber numberWithInt:kDefaultPageSize],
                                                         @"offset" : [NSNumber numberWithInt:
                                                                      (int)pageNumber * (int)kDefaultPageSize],
                                                         kPFApiKeyKey : kPFApiKey}
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation,
                                                        NSError *error) {
                                                  [self onError:operation
                                                          error:error
                                                        failure:failure];
                                              }];
}

- (void)about:(NSNumber *)userId
      success:(PFApiAboutSuccessBlock)success
      failure:(PFApiErrorHandlerBlock)failure; {
    
    PFAbout *about = [[PFAbout alloc] init];
    [about setUserId:userId];
    
    [[RKObjectManager sharedManager] getObject:about
                                          path:[about endPointWithUserIdPath]
                                    parameters:@{ kPFApiKeyKey : kPFApiKey }
                                       success:^(RKObjectRequestOperation *operation,
                                                 RKMappingResult *mappingResult) {
                                           success(about);
                                       }
                                       failure:^(RKObjectRequestOperation *operation,
                                                 NSError *error) {
                                           [self onError:operation
                                                   error:error
                                                 failure:failure];
                                       }];
}

- (void)accept:(NSString *)token
       success:(PFApiUserSuccessBlock)success
       failure:(PFApiErrorHandlerBlock)failure; {
    
    PFUzer *user = [[PFUzer alloc] init];
    [user setToken:token];
    
    [[RKObjectManager sharedManager] postObject:nil
                                           path:[user endPointConnectionAcceptPath]
                                     parameters:@{ kPFApiKeyKey : kPFApiKey }
                                        success:^(RKObjectRequestOperation *operation,
                                                  RKMappingResult *mappingResult) {
                                            
                                            [[PFGoogleAnalytics shared] acceptedConnection];
                                            
                                            PFUzer *user = [[mappingResult array] objectAtIndex:0];
                                            success(user);
                                        } failure:^(RKObjectRequestOperation *operation,
                                                    NSError *error) {
                                            [self onError:operation
                                                    error:error
                                                  failure:failure];
                                        }];
}

- (void)categoryById:(NSNumber *)categoryId
             success:(PFApiSystemCategorySuccessBlock)success
             failure:(PFApiErrorHandlerBlock)failure; {
    
    PFSystemCategory *category = [[PFSystemCategory alloc] init];
    [category setCategoryId:categoryId];
    
    [[RKObjectManager sharedManager] getObject:category
                                          path:[category endPointWithCategoryIdPath]
                                    parameters:@{ kPFApiKeyKey : kPFApiKey }
                                       success:^(RKObjectRequestOperation *operation,
                                                 RKMappingResult *mappingResult) {
                                           success(category);
                                       }
                                       failure:^(RKObjectRequestOperation *operation,
                                                 NSError *error) {
                                           [self onError:operation
                                                   error:error
                                                 failure:failure];
                                       }];
}

- (void)counts:(PFApiCountsSuccessBlock)success
       failure:(PFApiErrorHandlerBlock)failure; {
    
    PFCount *count = [[PFCount alloc] init];
    
    [[RKObjectManager sharedManager] getObject:count
                                          path:[PFCount endPoint]
                                    parameters:@{ kPFApiKeyKey : kPFApiKey }
                                       success:^(RKObjectRequestOperation *operation,
                                                 RKMappingResult *mappingResult) {
                                           success(count);
                                       } failure:^(RKObjectRequestOperation *operation,
                                                   NSError *error) {
                                           [self onError:operation
                                                   error:error
                                                 failure:failure];
                                       }];
}

- (void)uploadImage:(NSNumber *)entryId
              bytes:(NSData *)bytes
               name:(NSString *)name
             dfault:(BOOL)dfault
                tag:(NSInteger)tag
           progress:(PFApiProgressBlock)progress   
            success:(PFApiMediaUploadSuccessBlock)success
            failure:(PFApiTaggedErrorHandlerBlock)failure; {
    
    PFMedia *media = [[PFMedia alloc] init];
    [media setMediaId:entryId];
    
    NSMutableURLRequest *request = [[RKObjectManager sharedManager]
                                    multipartFormRequestWithObject:nil
                                    method:RKRequestMethodPOST
                                    path:[media endPointWithIdPath]
                                    parameters:@{ kPFApiKeyKey : kPFApiKey,
                                                  @"default" : dfault ? @"true" : @"false" }
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        
                                        [formData appendPartWithFileData:bytes
                                                                    name:@"file"
                                                                fileName:@"photo.jpeg"
                                                                mimeType:@"image/jpeg"];
                                    }];
    
    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager]
                                           objectRequestOperationWithRequest:request
                                           success:^(RKObjectRequestOperation *operation,
                                                     RKMappingResult *mappingResult) {
                                               PFMedia *media = [[mappingResult array] objectAtIndex:0];
                                               success(media);
                                           } failure:^(RKObjectRequestOperation *operation,
                                                       NSError *error) {
                                               failure(error, tag);
                                           }];
    
    [operation.HTTPRequestOperation setUploadProgressBlock:^(NSUInteger bytesWritten,
                                                            long long totalBytesWritten,
                                                            long long totalBytesExpectedToWrite) {
        
        progress(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite, tag);
    }];
    
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

- (void)onError:(RKObjectRequestOperation *)operation
          error:(NSError *)error
        failure:(PFApiErrorHandlerBlock)failure; {
    
    NSError *err = failure(error);
    if(err) [self onErrorReturnedFromCaller:err
                                 statusCode:[self statusCode:operation]];
}

- (NSInteger)statusCode:(RKObjectRequestOperation *)operation; {
    
    return operation.HTTPRequestOperation.response.statusCode;
}

- (void)onErrorReturnedFromCaller:(NSError *)error
                       statusCode:(NSInteger)statusCode; {
}


@end
