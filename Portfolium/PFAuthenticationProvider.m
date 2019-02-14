//
//  PFAuthenticationProvider.m
//  Portfolium
//
//  Created by John Eisberg on 6/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFAuthenticationProvider.h"
#import "PFUzer.h"
#import "PFToken.h"
#import "PFAvatar.h"

static const NSString *kUserDefaultsToken = @"kUserDefaultsToken";
static const NSString *kUserDefaultsUserId = @"kUserDefaultsUserId";
static const NSString *kUserDefaultsFirstname = @"kUserDefaultsFirstname";
static const NSString *kUserDefaultsLastname = @"kUserDefaultsLastname";
static const NSString *kUserDefaultsUsername = @"kUserDefaultsUsername";
static const NSString *kUserDefaultsAvatarUrl = @"kUserDefaultsAvatarUrl";
static const NSString *kUserDefaultsCoverUrl = @"kUserDefaultsCoverUrl";
static const NSString *kUserDefaultsLocation = @"kUserDefaultsLocation";
static const NSString *kUserDefaultsEmailAddress = @"kUserDefaultsEmailAddress";
static const NSString *kUserDefaultsGender = @"kUserDefaultsGender";
static const NSString *kUserDefaultsPhone = @"kUserDefaultsPhone";
static const NSString *kUserDefaultsBirthday = @"kUserDefaultsBirthday";
static const NSString *kUserDefaultsSchool = @"kUserDefaultsSchool";
static const NSString *kUserDefaultsMajor = @"kUserDefaultsMajor";
static const NSString *kUserDefaultsType = @"kUserDefaultsType";
static const NSString *kUserDefaultsTagline = @"kUserDefaultsTagline";
static const NSString *kUserDefaultsCreatedAt = @"kUserDefaultsCreatedAt";
static const NSString *kUserDefaultsProvider = @"kUserDefaultsProvider";
static const NSString *kUserDefaultsOnboarded = @"kUserDefaultsOnboarded";
static const NSString *kUserDefaultsTutorialized = @"kUserDefaultsTutorialized";

@implementation PFAuthenticationProvider

+ (PFAuthenticationProvider *)shared; {
    
    static dispatch_once_t once;
    static PFAuthenticationProvider *shared;
    
    dispatch_once(&once, ^{
        
        shared = [[PFAuthenticationProvider alloc] init];
    });
    
    return shared;
}

- (void)logout; {
    
    @synchronized (self) {
        
        if([self token] || [self userId]) {
            
            [self saveUser:nil provider:-1];
            [[self delegate] authenticationProviderDidLogout:self];
        }
    }
}

- (NSString *)token; {
    
    return (NSString *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsToken];
}

- (NSNumber *)userId; {
    
    return (NSNumber *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsUserId];
}

- (NSString *)firstname; {
    
    return (NSString *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsFirstname];
}

- (NSString *)lastname; {
    
    return (NSString *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsLastname];
}

- (NSString *)username; {
    
    return (NSString *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsUsername];
}

- (NSString *)avatarUrl; {
    
    return (NSString *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsAvatarUrl];
}

- (NSString *)coverUrl; {
    
    return (NSString *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsCoverUrl];
}

- (NSString *)location; {
    
    return (NSString *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsLocation];
}

- (NSString *)emailAddress; {
    
    return (NSString *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsEmailAddress];
}

- (NSString *)gender; {
    
    return (NSString *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsGender];
}

- (NSString *)phone; {
    
    return (NSString *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsPhone];
}

- (NSDate *)birthday; {
    
    return (NSDate *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsBirthday];
}

- (NSString *)school; {
    
    return (NSString *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsSchool];
}

- (NSString *)major; {
    
    return (NSString *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsMajor];
}

- (NSNumber *)type; {
    
    return (NSNumber *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsType];
}

- (NSString *)tagline; {
    
    return (NSString *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsTagline];
}

- (NSDate *)createdAt; {
    
    return (NSDate *)[[NSUserDefaults standardUserDefaults]
                        objectForKey:(NSString *)kUserDefaultsCreatedAt];
}

- (PFAuthenticationProviderDomain)provider; {
    
    return (PFAuthenticationProviderDomain)
        [[NSUserDefaults standardUserDefaults] integerForKey:
            (NSString *)kUserDefaultsProvider];
}

- (BOOL)onboarded; {
    
    return (BOOL)[[NSUserDefaults standardUserDefaults]
                  boolForKey:(NSString *)kUserDefaultsOnboarded];
}

- (void)setOnboarded:(BOOL)onboarded; {
    
    [[NSUserDefaults standardUserDefaults] setBool:onboarded
                                            forKey:(NSString *)kUserDefaultsOnboarded];
}

- (BOOL)tutorialized; {
    
    return (BOOL)[[NSUserDefaults standardUserDefaults]
                  boolForKey:(NSString *)kUserDefaultsTutorialized];
}

- (void)setTutorialized:(BOOL)tutorialized; {
    
    [[NSUserDefaults standardUserDefaults] setBool:tutorialized
                                            forKey:(NSString *)kUserDefaultsTutorialized];
}

- (BOOL) isLoggedIn; {
    
    return [self token] != nil;
}

- (BOOL)userIdIsLoggedInUser:(NSNumber *)userId; {
    
    return (userId != nil) && [[self userId] isEqualToNumber:userId];
}

- (void)saveUser:(PFUzer *)user
        provider:(PFAuthenticationProviderDomain)provider; {
    
    if([user authToken] != nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[[user authToken] token]
                                                  forKey:(NSString *)kUserDefaultsToken];
        
        [[NSUserDefaults standardUserDefaults] setObject:[user userId]
                                                  forKey:(NSString *)kUserDefaultsUserId];
        
        [[NSUserDefaults standardUserDefaults] setObject:[user firstname]
                                                  forKey:(NSString *)kUserDefaultsFirstname];
        
        [[NSUserDefaults standardUserDefaults] setObject:[user lastname]
                                                  forKey:(NSString *)kUserDefaultsLastname];
        
        [[NSUserDefaults standardUserDefaults] setObject:[user username]
                                                  forKey:(NSString *)kUserDefaultsUsername];
        
        [[NSUserDefaults standardUserDefaults] setObject:[[user avatar] dynamic]
                                                  forKey:(NSString *)kUserDefaultsAvatarUrl];
        
        [[NSUserDefaults standardUserDefaults] setObject:[[user cover] url]
                                                  forKey:(NSString *)kUserDefaultsCoverUrl];
        
        [[NSUserDefaults standardUserDefaults] setObject:[user location]
                                                  forKey:(NSString *)kUserDefaultsLocation];
        
        [[NSUserDefaults standardUserDefaults] setObject:[user email]
                                                  forKey:(NSString *)kUserDefaultsEmailAddress];
        
        [[NSUserDefaults standardUserDefaults] setObject:[user gender]
                                                  forKey:(NSString *)kUserDefaultsGender];
        
        [[NSUserDefaults standardUserDefaults] setObject:[user phone]
                                                  forKey:(NSString *)kUserDefaultsPhone];
        
        [[NSUserDefaults standardUserDefaults] setObject:[user birthday]
                                                  forKey:(NSString *)kUserDefaultsBirthday];
        
        [[NSUserDefaults standardUserDefaults] setObject:[user school]
                                                  forKey:(NSString *)kUserDefaultsSchool];
        
        [[NSUserDefaults standardUserDefaults] setObject:[user major]
                                                  forKey:(NSString *)kUserDefaultsMajor];
        
        [[NSUserDefaults standardUserDefaults] setObject:[user type]
                                                  forKey:(NSString *)kUserDefaultsType];
        
        [[NSUserDefaults standardUserDefaults] setObject:[user tagline]
                                                  forKey:(NSString *)kUserDefaultsTagline];
        
        [[NSUserDefaults standardUserDefaults] setObject:[user createdAt]
                                                  forKey:(NSString *)kUserDefaultsCreatedAt];
        
        [[NSUserDefaults standardUserDefaults] setInteger:provider
                                                   forKey:(NSString *)kUserDefaultsProvider];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO
                                                forKey:(NSString *)kUserDefaultsOnboarded];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsToken];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsUserId];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsFirstname];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsLastname];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsUsername];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsAvatarUrl];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsCoverUrl];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsLocation];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsEmailAddress];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsGender];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsPhone];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsBirthday];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsSchool];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsMajor];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsType];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsTagline];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:(NSString *)kUserDefaultsCreatedAt];
        
        [[NSUserDefaults standardUserDefaults] setInteger:-1
                                                   forKey:(NSString *)kUserDefaultsProvider];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO
                                                   forKey:(NSString *)kUserDefaultsOnboarded];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loginUser:(PFUzer *)user
         provider:(PFAuthenticationProviderDomain)provider; {
    
    [self saveUser:user provider:provider];
    [self setOnboarded:[[user onboarded] boolValue]];
    
    [[self delegate] authenticationProviderDidLogin:self];
}

- (PFProfile *)providerToProfile; {
    
    PFAvatar *avatar = [[PFAvatar alloc] init];
    [avatar setUrl:[self avatarUrl]];
    
    PFProfile *profile = [[PFProfile alloc] init];
    [profile setUserId:[self userId]];
    [profile setFirstname:[self firstname]];
    [profile setLastname:[self lastname]];
    [profile setUsername:[self username]];
    [profile setAvatar:avatar];
    
    return profile;
}

- (void)userUpdatedProfile:(NSString *)firstname
                  lastname:(NSString *)lastname
                  username:(NSString *)username
                  location:(NSString *)location; {
    
    [[NSUserDefaults standardUserDefaults] setObject:firstname
                                              forKey:(NSString *)kUserDefaultsFirstname];
    
    [[NSUserDefaults standardUserDefaults] setObject:lastname
                                              forKey:(NSString *)kUserDefaultsLastname];
    
    [[NSUserDefaults standardUserDefaults] setObject:username
                                              forKey:(NSString *)kUserDefaultsUsername];
    
    [[NSUserDefaults standardUserDefaults] setObject:location
                                              forKey:(NSString *)kUserDefaultsLocation];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)userUpdatedAvatarUrl:(NSString *)avatarUrl; {

    [[NSUserDefaults standardUserDefaults] setObject:avatarUrl
                                              forKey:(NSString *)kUserDefaultsAvatarUrl];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)userUpdatedCoverUrl:(NSString *)coverUrl; {
    
    [[NSUserDefaults standardUserDefaults] setObject:coverUrl
                                              forKey:(NSString *)kUserDefaultsCoverUrl];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)userUpdatedEmail:(NSString *)email; {
    
    [[NSUserDefaults standardUserDefaults] setObject:email
                                              forKey:(NSString *)kUserDefaultsEmailAddress];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
