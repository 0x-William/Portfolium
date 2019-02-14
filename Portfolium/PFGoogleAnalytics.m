//
//  PFAnalytics.m
//  Portfolium
//
//  Created by John Eisberg on 10/4/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFGoogleAnalytics.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "PFEntry.h"

static NSInteger kInterval = 10;
static NSString *kKey = @"UA-52490308-4";

static NSString *kActionLaunchKey = @"launch";
static NSString *kActionAuthKey = @"auth";
static NSString *kActionEntryKey = @"entry";
static NSString *kActionIntroKey = @"intro";
static NSString *kActionMessageKey = @"message";
static NSString *kActionNotificationKey = @"notification";
static NSString *kActionSearchKey = @"search";
static NSString *kActionSettingsKey = @"settings";
static NSString *kActionUserKey = @"user";
static NSString *kActionConnectionKey = @"connection";
static NSString *kActionShareKey = @"share";

NSString *const kIntroPage = @"intro";
NSString *const kOnboardingInterestsPage = @"onboarding/interests";
NSString *const kOnboardingTypePage = @"onboarding/type";
NSString *const kOnboardingProfilePage = @"onboarding/profile";
NSString *const kHomePage = @"home";
NSString *const kInterestsPage = @"interests";
NSString *const kSearchPage = @"search";
NSString *const kSearchResultsPage = @"search/results";
NSString *const kInvitePage = @"invite";
NSString *const kMePage = @"me";
NSString *const kDetailPage = @"edp";
NSString *const kUploadPage = @"entry/add";
NSString *const kLoginPage = @"login";
NSString *const kJoinPage = @"join";
NSString *const kJoinWithEmailPage = @"join/email";
NSString *const kForgotPage = @"forgot";
NSString *const kCategoriesPage = @"categories";
NSString *const kCategoryEntriesPage = @"entries/category";
NSString *const kEntryCommentsPage = @"entry/comments";
NSString *const kProfilePage = @"user";
NSString *const kNotificationsPage = @"notifications";
NSString *const kMessagesPage = @"messages";
NSString *const kMessageThreadPage = @"message";
NSString *const kMessageThreadUsersPage = @"message/users";
NSString *const kMessageComposePage = @"message/compose";
NSString *const kMessageReplyPage = @"message/reply";
NSString *const kSettingsPage = @"settings";
NSString *const kEmailPage = @"email";
NSString *const kPasswordPage = @"password";
NSString *const kEditProfilePage = @"profile";
NSString *const kTermsPage = @"terms";
NSString *const kPrivacyPage = @"privacy";

@implementation PFGoogleAnalytics : NSObject

+ (PFGoogleAnalytics *)shared; {
    
    static dispatch_once_t once;
    static PFGoogleAnalytics *shared;
    
    dispatch_once(&once, ^{
        
        shared = [[PFGoogleAnalytics alloc] init];
        
        [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
        [[GAI sharedInstance] setDispatchInterval:kInterval];
        [[GAI sharedInstance] trackerWithTrackingId:kKey];
        
        [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelError];
    });
    
    return shared;
}

- (void)applicationDidLaunch; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionLaunchKey
                                                          action:@"application_launch"
                                                           label:nil
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)loggedOut; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionAuthKey
                                                          action:@"logout"
                                                           label:nil
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)loggedInWithFacebook; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionAuthKey
                                                          action:@"login"
                                                           label:@"facebook"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)loggedInWithLinkedIn; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionAuthKey
                                                          action:@"login"
                                                           label:@"linkedin"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)loggedInWithEmail; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionAuthKey
                                                          action:@"login"
                                                           label:@"email"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)joinedWithFacebook; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionAuthKey
                                                          action:@"join"
                                                           label:@"facebook"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)joinedWithLinkedIn; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionAuthKey
                                                          action:@"join"
                                                           label:@"linkedin"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)joinedWithEmail; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionAuthKey
                                                          action:@"join"
                                                           label:@"email"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)viewedIntroScreens; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionIntroKey
                                                          action:@"finished"
                                                           label:nil
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)selectedEntryType:(PFEntryType)entryType; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionEntryKey
                                                          action:@"type"
                                                           label:[PFEntry entryTypeToString:entryType]
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)addedEntry:(PFEntryType)entryType; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionEntryKey
                                                          action:@"add"
                                                           label:[PFEntry entryTypeToString:entryType]
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)likedEntryFromFeed; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionEntryKey
                                                          action:@"like"
                                                           label:@"feed"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)likedEntryFromDetail; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionEntryKey
                                                          action:@"like"
                                                           label:@"edp"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)commentedOnEntryFromFeed; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionEntryKey
                                                          action:@"comment"
                                                           label:@"feed"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)commentedOnEntryFromDetail; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionEntryKey
                                                          action:@"comment"
                                                           label:@"edp"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)composedNewMessage; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionMessageKey
                                                          action:@"compose"
                                                           label:nil
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)repliedToMessage; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionMessageKey
                                                          action:@"reply"
                                                           label:nil
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)archivedMessageFromSwipe; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionMessageKey
                                                          action:@"archive"
                                                           label:@"swipe"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)archivedMessageFromTabBar; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionMessageKey
                                                          action:@"archive"
                                                           label:@"tabbar"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)deletedMessageFromTabBar; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionMessageKey
                                                          action:@"delete"
                                                           label:@"tabbar"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)openedNotification; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionNotificationKey
                                                          action:@"click"
                                                           label:nil
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)searchedForTerm:(NSString *)searchTerm; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionSearchKey
                                                          action:@"term"
                                                           label:searchTerm
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)changedEmailNotificationSetting; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionSettingsKey
                                                          action:@"notification"
                                                           label:@"email"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)updatedEmail; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionSettingsKey
                                                          action:@"email"
                                                           label:nil
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)updatedPassword; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionSettingsKey
                                                          action:@"password"
                                                           label:nil
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)uploadedAvatarFromSettings; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionUserKey
                                                          action:@"avatar"
                                                           label:@"settings"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)uploadedAvatarFromOnboarding; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionUserKey
                                                          action:@"avatar"
                                                           label:@"onboarding"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)uploadedCoverFromSettings; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionUserKey
                                                          action:@"cover"
                                                           label:@"settings"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)uploadedCoverFromOnboarding; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionUserKey
                                                          action:@"cover"
                                                           label:@"onboarding"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)updatedProfileFromSettings; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionUserKey
                                                          action:@"profile"
                                                           label:@"settings"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)updatedProfileFromOnboarding; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionUserKey
                                                          action:@"profile"
                                                           label:@"onboarding"
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)requestedToConnect; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionConnectionKey
                                                          action:@"request"
                                                           label:nil
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)acceptedConnection; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionConnectionKey
                                                          action:@"accept"
                                                           label:nil
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)shareApp; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionShareKey
                                                          action:@"invite"
                                                           label:nil
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)shareEntry; {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:kActionShareKey
                                                          action:@"entry"
                                                           label:nil
                                                           value:nil] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)track:(NSString *)page; {

    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName
           value:page];
    
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)track:(NSString *)page withIdentifier:(NSNumber *)identifier; {
    
    NSString *p = [NSString stringWithFormat:@"%@/%@", page, [identifier stringValue]];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName
           value:p];
    
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

@end
