//
//  PFFacebook.m
//  Portfolium
//
//  Created by John Eisberg on 6/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFFacebook.h"
#import "PFFacebookUtils.h"
#import "FBSession.h"
#import "FBAccessTokenData.h"
#import "FBRequest.h"

static NSString *const kEmail = @"email";
static NSString *const kProviderId = @"facebook";
static NSString *const kId = @"id";
static NSString *const kLink = @"link";
static NSString *const kFirstName = @"first_name";
static NSString *const kSecret = @"";

@implementation PFFacebook

+ (PFFacebook *)shared; {
    
    static PFFacebook *_shared = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}

- (void)buttonAction:(OAuthSuccessBlock)success
              cancel:(OAuthCancelBlock)cancel
               error:(OAuthErrorBlock)error; {
    
    [PFFacebookUtils logInWithPermissions:@[@"email",
                                            @"user_education_history",
                                            @"user_location",
                                            @"user_work_history",
                                            @"user_birthday"]
     
                                    block:^(PFUser *user, NSError *err) {
                                        
                                        if (!user) {
                                            if (!error) {
                                                cancel();
                                            } else {
                                                error(err);
                                            }
                                            
                                        } else if ([user isNew]) {
                                            
                                            [self doButtonAction:user
                                                             err:err
                                                         success:success
                                                          cancel:cancel
                                                           error:error];
                                        } else {
                                            
                                            [self doButtonAction:user
                                                             err:err
                                                         success:success
                                                          cancel:cancel
                                                           error:error];
                                        }
                                    }];
}

- (void)doButtonAction:(PFUser *)user
                   err:(NSError *)err
               success:(OAuthSuccessBlock)success
                cancel:(OAuthCancelBlock)cancel
                 error:(OAuthErrorBlock)error; {
    if(!err) {
        
        NSString *accessToken = [[FBSession.activeSession accessTokenData] accessToken];
        FBRequest *request = [FBRequest requestForMe];
        
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *err) {
            
            if(!err) {
                
                NSString *providerId = kProviderId;
                NSString *providerUserId = [result valueForKey:kId];
                NSString *profileUrl = [result valueForKey:kLink];
                NSString *displayName = [result valueForKey:kFirstName];
                NSString *email = [result valueForKey:kEmail];
                
                success(providerId, providerUserId, accessToken, accessToken, displayName, profileUrl, email);
                
            } else error(err);
        }];
        
    } else error(err);
}

- (void)closeSession; {
    
    [PFUser logOut];
}

- (NSString *)provider; {
    
    return kProviderId;
}

@end
