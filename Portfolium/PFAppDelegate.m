//
//  PFAppDelegate.m
//  Portfolium
//
//  Created by John Eisberg on 6/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFAppDelegate.h"
#import "FBAppCall.h"
#import "PFFacebookUtils.h"
#import "PFLoginVC.h"
#import "Parse.h"
#import "PFTwitter.h"
#import "PFApi.h"
#import "PFHomeVC.h"
#import "PFLinkedIn.h"
#import "PFAppContainerVC.h"
#import "PFLandingVC.h"
#import "PFOnboardingVC.h"
#import "PFColor.h"
#import <Crashlytics/Crashlytics.h>
#import "PFGoogleAnalytics.h"
#import "ATConnect.h"
#import "PFMVVModel.h"
#import "Intercom.h"
#import "NSString+PFExtensions.h"
#import "PFIntercom.h"
#import "PFOnboarding.h"
#import "PFApi.h"

static NSString *kNotificationData = @"aps";
static NSString *kNotificationBadge = @"badge";
static NSString *kNotificationChannels = @"channels";

@implementation PFAppDelegate

+ (PFAppDelegate *)shared; {
    
    return (PFAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions; {
    
    // leave this as the 1st line of code in the didFinishLaunchingWithOptions function
    [Crashlytics startWithAPIKey:@"af9f6dc15e3d5cadbac0123a5dae40826295a7ef"];
    
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    
    [[PFAuthenticationProvider shared] setDelegate:self];
    
    [Parse setApplicationId:@"m21lu12wgApPWKhps1YDeR3sEWUo2klpt82C1bKS"
                  clientKey:@"8zi0NN5ZnhBN1UwSJRJy0gJug4Lo1EQQbIltfnje"];
    
    [PFFacebookUtils initializeFacebook];
    [PFTwitter initializeTwitter];
    [[PFLinkedIn shared] initializeLinkedIn];

    [[PFGoogleAnalytics shared] applicationDidLaunch];
    [ATConnect sharedConnection].apiKey = @"86bcd6a8991b27ed43f37c7a024f6d73a8b23fe32fc1575441a2140269ae1246";
    [Intercom setApiKey:@"ios_sdk-8b213ec5154d3b6a5264fe2a7cbf95ee6541891a" forAppId:@"f9esc4wf"];
    
    [[self window] setBackgroundColor:[PFColor lightGrayColor]];
    
    if([[PFAuthenticationProvider shared] isLoggedIn]) {
        
        [self fillMVVMModel:[PFAuthenticationProvider shared]];
        [self notifyApptentive:[PFAuthenticationProvider shared]];
        [self notifyIntercom:[PFAuthenticationProvider shared]];
        
        [[PFApi shared] setAuthenticated:[[PFAuthenticationProvider shared] token]];
        
        [self setCounts];
        
        if(![[PFAuthenticationProvider shared] onboarded]) {
            
            [[PFOnboarding shared] init:[PFAuthenticationProvider shared]];            
            [[PFAppContainerVC shared] setRootViewController:[PFOnboardingVC _new]];
            
        } else {
     
            [[PFAppContainerVC shared] setDefaultRootViewController];
        }
    
    } else {
        
        [[PFAppContainerVC shared] setRootViewController:[PFLandingVC _new]];
    }
    
    [[self window] setRootViewController:[PFAppContainerVC shared]];
    [[self window] makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application; {
    
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
    [application setApplicationIconBadgeNumber:0];
    
    [self clearRemoteNotificationCount];
}

- (void)applicationWillResignActive:(UIApplication *)application; {
}

- (void)applicationDidEnterBackground:(UIApplication *)application; {
}

- (void)applicationWillEnterForeground:(UIApplication *)application; {
}

- (void)applicationWillTerminate:(UIApplication *)application; {
}

- (void)registerForNotificationTypes:(UIApplication *)application; {
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
                                                         UIUserNotificationTypeBadge |
                                                         UIUserNotificationTypeSound
                                              categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    } else {
        
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    [self notifyParse:[PFAuthenticationProvider shared]];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:
    (UIUserNotificationSettings *)notificationSettings {
    
    [application registerForRemoteNotifications];
    
    [self notifyParse:[PFAuthenticationProvider shared]];
}

- (void)application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error; {
}

- (void)application:(UIApplication *)application
    handleActionWithIdentifier:(NSString *)identifier
    forRemoteNotification:(NSDictionary *)userInfo
    completionHandler:(void(^)())completionHandler; {
    
    if ([identifier isEqualToString:@"declineAction"]) {
    } else if ([identifier isEqualToString:@"answerAction"]) {
    }
}

- (BOOL)isRegisteredForNotifications:(UIApplication *)application; {
    
    return NO;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification {
    
    switch (application.applicationState) {
            
        case UIApplicationStateActive: {
            
            [self setCountAndClearRemoteNotificationCount];
            
            break;
        }
            
        case UIApplicationStateInactive: {
            
            [self setCountAndClearRemoteNotificationCount];
            
            break;
        }
            
        case UIApplicationStateBackground:
            
            [self setCountAndClearRemoteNotificationCount];
            
            break;
            
        default:
            
            break;
    }
}

#pragma mark - ADAuthenticationProviderDelegate

- (void)authenticationProviderDidLogin:(PFAuthenticationProvider *)provider {
    
    [[PFApi shared] setAuthenticated:[provider token]];
    
    [self fillMVVMModel:provider];
    [self notifyApptentive:provider];
    [self notifyIntercom:provider];
    [self setCounts];
    
    if(![self isRegisteredForNotifications:[UIApplication sharedApplication]]) {
        
        [self registerForNotificationTypes:[UIApplication sharedApplication]];
    
    } else {
        
        [self notifyParse:[PFAuthenticationProvider shared]];
    }
    
    if(![provider onboarded]) {
        
        [[PFOnboarding shared] init:provider];
        [[PFAppContainerVC shared] setRootViewController:[PFOnboardingVC _new]
                                               animation:PFAppContainerAnimationSlideLeft];
        
    } else {
        
        [[PFAppContainerVC shared] setRootViewController:[PFHomeVC _new]
                                               animation:PFAppContainerAnimationSlideLeft];
    }
}

- (void)authenticationProviderDidLogout:(PFAuthenticationProvider *)provider {
    
    [[PFApi shared] setUnauthenticated];
    
    [Intercom endSession];
    
    [self resignParseChannel];
    
    [[PFGoogleAnalytics shared] loggedOut];
    
    [[PFAppContainerVC shared] setRootViewController:[PFLandingVC _new]
                                           animation:PFAppContainerAnimationSlideDown];
}

- (void)fillMVVMModel:(PFAuthenticationProvider *)provider; {
    
    NSString *fullname = [NSString stringWithFormat:@"%@ %@",
                          [provider firstname],
                          [provider lastname]];
    
    [[PFMVVModel shared] setUserId:[provider userId]];
    [[PFMVVModel shared] setFirstname:[provider firstname]];
    [[PFMVVModel shared] setLastname:[provider lastname]];
    [[PFMVVModel shared] setUsername:[provider username]];
    [[PFMVVModel shared] setFullname:fullname];
    [[PFMVVModel shared] setLocation:[provider location]];
    [[PFMVVModel shared] setAvatarUrl:[provider avatarUrl]];
    [[PFMVVModel shared] setCoverUrl:[provider coverUrl]];
}

- (void)notifyApptentive:(PFAuthenticationProvider *)provider; {
    
    [[ATConnect sharedConnection] setInitialUserEmailAddress: [provider emailAddress]];
    [[ATConnect sharedConnection] setInitialUserName: [[PFMVVModel shared] fullname]];
}

- (void)notifyIntercom:(PFAuthenticationProvider *)provider; {
    
    [PFIntercom init:provider mvvm:[PFMVVModel shared]];
}

- (void)notifyParse:(PFAuthenticationProvider *)provider; {
    
    NSString *userChannel = [NSString stringWithFormat:@"user_%@", [provider userId]];
    NSString *globalChannel = [NSString stringWithFormat:@"global"];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:userChannel forKey:kNotificationChannels];
    [currentInstallation addUniqueObject:globalChannel forKey:kNotificationChannels];
    [currentInstallation saveInBackground];
}

- (void)resignParseChannel; {
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation.channels = [NSArray array];
    
    [currentInstallation saveInBackground];
}

- (void)setCounts; {
    
    [[PFApi shared] counts:^(PFCount *count) {
        
        [self setNotifications:[count notifications]];
        [self setMessages:[count messages]];
    
    } failure:^NSError *(NSError *error) {
        
        return error;
    }];
}

- (void)resetNotifications; {
    
    [[PFAppDelegate shared] setNotifications:@0];
}

- (void)setCountAndClearRemoteNotificationCount; {
    
    [self setCounts];
    [self clearRemoteNotificationCount];
}

- (void)clearRemoteNotificationCount; {
    
    [[PFInstallation currentInstallation] setObject:@0 forKey:kNotificationBadge];
    [[PFInstallation currentInstallation] saveEventually];
}

- (void)messageRead; {

    [[PFAppDelegate shared] setMessages:@([[self messages] integerValue] - 1)];
}

@end
