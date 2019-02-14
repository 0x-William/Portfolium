//
//  PFTwitter.h
//  Portfolium
//
//  Created by John Eisberg on 6/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFOAuthTypes.h"
#import "PFTwitterProvider.h"

FOUNDATION_EXPORT NSString *const kTwitterConsumerKey;
FOUNDATION_EXPORT NSString *const kTwitterConsumerSecret;

@class ACAccount;

@interface PFTwitter : NSObject<PFOAuthDelegate>

+ (void)initializeTwitter;

+ (void)loginUserWithAccount:(ACAccount *)twitterAccount
                     success:(OAuthSuccessBlock)success
                       error:(OAuthErrorBlock)error;

+ (void)loginUserWithTwitterEngine:(id<PFTwitterProviderDelegate>) delegate;

@end
