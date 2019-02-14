//
//  PFAnalytics.h
//  Portfolium
//
//  Created by John Eisberg on 10/4/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFEntry.h"

FOUNDATION_EXPORT NSString *const kIntroPage;
FOUNDATION_EXPORT NSString *const kOnboardingInterestsPage;
FOUNDATION_EXPORT NSString *const kOnboardingTypePage;
FOUNDATION_EXPORT NSString *const kOnboardingProfilePage;
FOUNDATION_EXPORT NSString *const kHomePage;
FOUNDATION_EXPORT NSString *const kInterestsPage;
FOUNDATION_EXPORT NSString *const kSearchPage;
FOUNDATION_EXPORT NSString *const kSearchResultsPage;
FOUNDATION_EXPORT NSString *const kInvitePage;
FOUNDATION_EXPORT NSString *const kMePage;
FOUNDATION_EXPORT NSString *const kDetailPage;
FOUNDATION_EXPORT NSString *const kUploadPage;
FOUNDATION_EXPORT NSString *const kLoginPage;
FOUNDATION_EXPORT NSString *const kJoinPage;
FOUNDATION_EXPORT NSString *const kJoinWithEmailPage;
FOUNDATION_EXPORT NSString *const kForgotPage;
FOUNDATION_EXPORT NSString *const kCategoriesPage;
FOUNDATION_EXPORT NSString *const kCategoryEntriesPage;
FOUNDATION_EXPORT NSString *const kEntryCommentsPage;
FOUNDATION_EXPORT NSString *const kProfilePage;
FOUNDATION_EXPORT NSString *const kNotificationsPage;
FOUNDATION_EXPORT NSString *const kMessagesPage;
FOUNDATION_EXPORT NSString *const kMessageThreadPage;
FOUNDATION_EXPORT NSString *const kMessageThreadUsersPage;
FOUNDATION_EXPORT NSString *const kMessageComposePage;
FOUNDATION_EXPORT NSString *const kMessageReplyPage;
FOUNDATION_EXPORT NSString *const kSettingsPage;
FOUNDATION_EXPORT NSString *const kEmailPage;
FOUNDATION_EXPORT NSString *const kPasswordPage;
FOUNDATION_EXPORT NSString *const kEditProfilePage;
FOUNDATION_EXPORT NSString *const kTermsPage;
FOUNDATION_EXPORT NSString *const kPrivacyPage;

@interface PFGoogleAnalytics : NSObject

+ (PFGoogleAnalytics *)shared;

- (void)applicationDidLaunch;

- (void)loggedOut;

- (void)loggedInWithFacebook;
- (void)loggedInWithLinkedIn;
- (void)loggedInWithEmail;

- (void)joinedWithFacebook;
- (void)joinedWithLinkedIn;
- (void)joinedWithEmail;

- (void)viewedIntroScreens;

- (void)selectedEntryType:(PFEntryType)entryType;
- (void)addedEntry:(PFEntryType)entryType;
- (void)likedEntryFromFeed;
- (void)likedEntryFromDetail;
- (void)commentedOnEntryFromFeed;
- (void)commentedOnEntryFromDetail;

- (void)composedNewMessage;
- (void)repliedToMessage;
- (void)archivedMessageFromSwipe;
- (void)archivedMessageFromTabBar;
- (void)deletedMessageFromTabBar;

- (void)searchedForTerm:(NSString *)searchTerm;

- (void)openedNotification;

- (void)changedEmailNotificationSetting;
- (void)updatedEmail;
- (void)updatedPassword;

- (void)uploadedAvatarFromSettings;
- (void)uploadedAvatarFromOnboarding;
- (void)uploadedCoverFromSettings;
- (void)uploadedCoverFromOnboarding;
- (void)updatedProfileFromSettings;
- (void)updatedProfileFromOnboarding;

- (void)requestedToConnect;
- (void)acceptedConnection;

- (void)shareApp;
- (void)shareEntry;

- (void)track:(NSString *)page;
- (void)track:(NSString *)page withIdentifier:(NSNumber *)identifier;

@end
