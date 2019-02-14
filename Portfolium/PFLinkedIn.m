//
//  PFLinkedIn.m
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFLinkedIn.h"
#import "LIALinkedInApplication.h"
#import "LIALinkedInHttpClient.h"
#import "NSString+PFExtensions.h"

static NSString *const kProviderId = @"linkedin";
static NSString *const kAccessToken = @"access_token";

@interface PFLinkedIn()

@property(nonatomic, strong) LIALinkedInHttpClient *client;

@end

@implementation PFLinkedIn

+ (PFLinkedIn *)shared; {
    
    static PFLinkedIn *_shared = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}

- (void)initializeLinkedIn; {
    
    LIALinkedInApplication *application =
    [LIALinkedInApplication applicationWithRedirectURL:@"https://portfolium.com/linkedin"
                                              clientId:@"7594zl17t0qfz5"
                                          clientSecret:@"9rrCOihafpr1W97j"
                                                 state:@"DCEEFWF45453sdffef424"
                                         grantedAccess:@[@"r_fullprofile", @"r_emailaddress"]];
    
    [self setClient:[LIALinkedInHttpClient
                     clientForApplication:application
                     presentingViewController:nil]];
}

- (void)buttonAction:(OAuthSuccessBlock)success
              cancel:(OAuthCancelBlock)cancel
               error:(OAuthErrorBlock)error; {
    
    
    [[self client] getAuthorizationCode:^(NSString *code) {
        [[self client] getAccessToken:code
                              success:^(NSDictionary *data) {
                                  
                                  NSString *accessToken = [data objectForKey:kAccessToken];
                                  
                                  success(kProviderId,
                                          [NSString empty],
                                          accessToken,
                                          accessToken,
                                          [NSString empty],
                                          [NSString empty],
                                          [NSString empty]);
                                  
                              } failure:^(NSError *err) {
                                  error(err);
                              }];
    } cancel:^{
        cancel();
    } failure:^(NSError *err) {
        error(err);
    }];
}

- (void)closeSession; {
}

- (NSString *)provider; {
    
    return kProviderId;
}

@end
