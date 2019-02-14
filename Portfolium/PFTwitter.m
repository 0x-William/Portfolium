//
//  PFTwitter.m
//  Portfolium
//
//  Created by John Eisberg on 6/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFTwitter.h"
#import "PFTwitterUtils.h"
#import "PFTwitterUtils+NativeTwitter.h"
#import "FHSTwitterEngine.h"

NSString *const kTwitterConsumerKey = @"X8cPNtjfqatRtzrpJs03xZ9lU";
NSString *const kTwitterConsumerSecret = @"J1uxDiFEUA9YjqjvD6uc4GmIbcoJmCjfdi8mBMy4AaDHE2E9xO";

static NSString *const kProviderId = @"twitter";

@implementation PFTwitter

+ (void)initializeTwitter; {
    
    [PFTwitterUtils initializeWithConsumerKey:kTwitterConsumerKey
                               consumerSecret:kTwitterConsumerSecret];
}

+ (void)loginUserWithAccount:(ACAccount *)twitterAccount
                     success:(OAuthSuccessBlock)success
                       error:(OAuthErrorBlock)error; {
    
    [PFTwitterUtils setNativeLogInSuccessBlock:^(PFUser *parseUser,
                                                 NSString *userTwitterId,
                                                 NSError *error) {
        
        [self onLoginSuccess:parseUser success:success];
    }];
    
    [PFTwitterUtils setNativeLogInErrorBlock:^(TwitterLogInError logInError) {
        
        NSError *err = [[NSError alloc] initWithDomain:@""
                                                  code:logInError
                                              userInfo:@{@"loginErrorCode" : @(logInError)}];
        
        [self onLoginFailure:err error:error];
    }];
    
    [PFTwitterUtils logInWithAccount:twitterAccount];
}

+ (void)onLoginSuccess:(PFUser *)user
               success:(OAuthSuccessBlock)success; {
    
    NSString *token = [[PFTwitterUtils twitter] authToken];
    NSString *secret = [[PFTwitterUtils twitter] authTokenSecret];
    
    NSLog(@"token %@", token);
    NSLog(@"secret %@", secret);
}

+ (void)onLoginFailure:(NSError *)err
                 error:(OAuthErrorBlock)error; {
    error(err);
}

+ (void)loginUserWithTwitterEngine:(id<PFTwitterProviderDelegate>) delegate; {
    
    [PFTwitterUtils initializeWithConsumerKey:kTwitterConsumerKey
                               consumerSecret:kTwitterConsumerSecret];
    
    FHSTwitterEngine *twitterEngine = [FHSTwitterEngine sharedEngine];
    FHSToken *token = [FHSTwitterEngine sharedEngine].accessToken;
    
    [PFTwitterUtils logInWithTwitterId:twitterEngine.authenticatedID
                            screenName:twitterEngine.authenticatedUsername
                             authToken:token.key
                       authTokenSecret:token.secret
                                 block:^(PFUser *user, NSError *error) {
                                     if (user) {
                                         
                                         [delegate onLoginUserWithTwitterEngineSuccess:user
                                                                                 token:token];
                                     } else {
                                         
                                         [delegate onLoginUserWithTwitterEngineError:error];
                                     }
                                 }];
}

- (void)buttonAction:(OAuthSuccessBlock)callback
              cancel:(OAuthCancelBlock)cancel
               error:(OAuthErrorBlock)error; {
}

- (void)closeSession; {
}

- (NSString *)provider; {
    
    return kProviderId;
}

@end
