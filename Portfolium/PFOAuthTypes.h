//
//  PFOAuthTypes.h
//  Portfolium
//
//  Created by John Eisberg on 6/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OAuthSuccessBlock)(NSString *providerId,
                                  NSString *providerUserId,
                                  NSString *token,
                                  NSString *secret,
                                  NSString *displayName,
                                  NSString *profileUrl,
                                  NSString *email);

typedef void (^OAuthCancelBlock)();
typedef void (^OAuthErrorBlock)(NSError *error);

@protocol PFOAuthDelegate <NSObject>

- (NSString *)provider;

- (void)buttonAction:(OAuthSuccessBlock)callback
              cancel:(OAuthCancelBlock)cancel
               error:(OAuthErrorBlock)error;

- (void)closeSession;

@end
