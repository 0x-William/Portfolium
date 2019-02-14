//
//  PFMVVModel.m
//  Portfolium
//
//  Created by John Eisberg on 8/27/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFMVVModel.h"
#import "PFProfile.h"
#import "PFAvatar.h"
#import "PFAuthenticationProvider.h"

@interface PFMVVModel ()

@end

@implementation PFMVVModel

+ (PFMVVModel *)shared; {
    
    static PFMVVModel *_shared = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        _shared = [[self alloc] init];
        
        [_shared setUserId:[[PFAuthenticationProvider shared] userId]];
        [_shared setUsername:@"mvvm_username"];
        [_shared setFirstname:@"mvvm_firstname"];
        [_shared setLastname:@"mvvm_lastname"];
        [_shared setFullname:@"mvvm_firstname mvvm_lastname"];
        [_shared setAvatarUrl:@"https://portfolium.com/images/users_default/3c8333a_17_2.jpg"];
    });
    
    return _shared;
}

- (NSString *)generateName:(PFProfile *)profile; {
    
    if([[profile userId] integerValue] == [[self userId] integerValue] ) {
        
        return [NSString stringWithFormat:@"%@ %@", [self firstname], [self lastname]];
    
    } else {
        
        return [NSString stringWithFormat:@"%@ %@", [profile firstname], [profile lastname]];
    }
}

- (NSString *)generateUsername:(PFProfile *)profile; {
    
    if([[profile userId] integerValue] == [[self userId] integerValue] ) {
        
        return [self username];
        
    } else {
        
        return [profile username];
    }
}

- (NSString *)generateAvatarUrl:(PFProfile *)profile; {
    
    if([[profile userId] integerValue] == [[self userId] integerValue] ) {
        
        return [self avatarUrl];
        
    } else {
        
        return [[profile avatar] dynamic];
    }
}

- (void)signalFullname:(NSString *)firstname
              lastname:(NSString *)lastname; {
    
    [self setFullname:[NSString stringWithFormat:@"%@ %@", firstname, lastname]];
}

- (void)signalLocation:(NSString *)location; {
    
    [self setLocation:location];
}

- (void)signalUsername:(NSString *)username; {
    
    [self setUsername:username];
}

- (void)signalAvatar:(NSString *)avatarUrl; {
    
    [self setAvatarUrl:avatarUrl];
}

- (void)signalCover:(NSString *)coverUrl; {
    
    [self setCoverUrl:coverUrl];
}

@end
