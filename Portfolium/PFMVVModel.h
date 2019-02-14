//
//  PFMVVModel.h
//  Portfolium
//
//  Created by John Eisberg on 8/27/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFProfile;

@interface PFMVVModel : NSObject

@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *firstname;
@property(nonatomic, strong) NSString *lastname;
@property(nonatomic, strong) NSString *fullname;
@property(nonatomic, strong) NSString *location;
@property(nonatomic, strong) NSString *avatarUrl;
@property(nonatomic, strong) NSString *coverUrl;

+ (PFMVVModel *)shared;

- (NSString *)generateName:(PFProfile *)profile;

- (NSString *)generateUsername:(PFProfile *)profile;

- (NSString *)generateAvatarUrl:(PFProfile *)profile;

- (void)signalFullname:(NSString *)firstname
              lastname:(NSString *)lastname;

- (void)signalLocation:(NSString *)location;

- (void)signalUsername:(NSString *)username;

- (void)signalAvatar:(NSString *)avatarUrl;

- (void)signalCover:(NSString *)coverUrl;

@end
