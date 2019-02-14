//
//  PFAuthenticationProvider.h
//  Portfolium
//
//  Created by John Eisberg on 6/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    PFAuthenticationProviderFacebook,
    PFAuthenticationProviderTwitter,
    PFAuthenticationProviderLinkedIn,
    PFAuthenticationProviderPortfolium
    
} PFAuthenticationProviderDomain;

@class PFAuthenticationProvider, PFUzer, PFProfile;

@protocol PFAuthenticationProviderDelegate<NSObject>

- (void)authenticationProviderDidLogin:(PFAuthenticationProvider *)provider;
- (void)authenticationProviderDidLogout:(PFAuthenticationProvider *)provider;

@end

@interface PFAuthenticationProvider : NSObject

@property(readonly) NSString *token;
@property(readonly) NSNumber *userId;
@property(readonly) NSString *firstname;
@property(readonly) NSString *lastname;
@property(readonly) NSString *username;
@property(readonly) NSString *avatarUrl;
@property(readonly) NSString *coverUrl;
@property(readonly) NSString *location;
@property(readonly) NSString *emailAddress;
@property(readonly) NSString *gender;
@property(readonly) NSString *phone;
@property(readonly) NSDate *birthday;
@property(readonly) NSString *school;
@property(readonly) NSString *major;
@property(readonly) NSNumber *type;
@property(readonly) NSString *tagline;
@property(readonly) NSDate *createdAt;
@property(readonly) PFAuthenticationProviderDomain provider;
@property(readonly) BOOL onboarded;
@property(readonly) BOOL tutorialized;

@property(nonatomic, weak) id<PFAuthenticationProviderDelegate> delegate;

+ (PFAuthenticationProvider *)shared;

- (void)logout;
- (BOOL)isLoggedIn;
- (BOOL)userIdIsLoggedInUser:(NSNumber *)userId;

- (void)loginUser:(PFUzer *)user
         provider:(PFAuthenticationProviderDomain)provider;

- (PFProfile *)providerToProfile;

- (void)setOnboarded:(BOOL)onboarded;
- (void)setTutorialized:(BOOL)tutorialized;

- (void)userUpdatedProfile:(NSString *)firstname
                  lastname:(NSString *)lastname
                  username:(NSString *)username
                  location:(NSString *)location;

- (void)userUpdatedAvatarUrl:(NSString *)avatarUrl;
- (void)userUpdatedCoverUrl:(NSString *)coverUrl;
- (void)userUpdatedEmail:(NSString *)email;
    
@end
