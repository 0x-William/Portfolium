//
//  PFUser.h
//  Portfolium
//
//  Created by John Eisberg on 6/12/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFModel.h"
#import "PFToken.h"
#import "PFProfile.h"
#import "PFCover.h"
#import "PFStatus.h"

@interface PFUzer : NSObject<PFModel>

@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *firstname;
@property(nonatomic, strong) NSString *lastname;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSNumber *points;
@property(nonatomic, strong) NSNumber *percent;
@property(nonatomic, strong) NSNumber *type;
@property(nonatomic, strong) NSNumber *views;
@property(nonatomic, strong) NSString *token;
@property(nonatomic, strong) NSString *avatarUrl;
@property(nonatomic, strong) NSString *coverUrl;
@property(nonatomic, strong) NSString *tagline;
@property(nonatomic, strong) NSString *location;
@property(nonatomic, strong) NSString *gender;
@property(nonatomic, strong) NSDate *birthday;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSNumber *linkedInId;
@property(nonatomic, strong) NSString *linkedInUrl;
@property(nonatomic, strong) NSString *facebookToken;
@property(nonatomic, strong) NSString *resume;
@property(nonatomic, strong) NSNumber *studentId;
@property(nonatomic, strong) NSString *schoolBadgeUrl;
@property(nonatomic, strong) NSNumber *privacy;
@property(nonatomic, strong) NSNumber *emailComment;
@property(nonatomic, strong) NSNumber *emailLike;
@property(nonatomic, strong) NSNumber *emailTag;
@property(nonatomic, strong) NSNumber *emailMessage;
@property(nonatomic, strong) NSNumber *emailNetwork;
@property(nonatomic, strong) NSNumber *emailEmployer;
@property(nonatomic, strong) NSDate *createdAt;
@property(nonatomic, strong) NSDate *updatedAt;
@property(nonatomic, strong) NSNumber *onboarded;
@property(nonatomic, strong) NSNumber *connected;
@property(nonatomic, strong) NSString *school;
@property(nonatomic, strong) NSString *major;
@property(nonatomic, strong) PFToken *authToken;
@property(nonatomic, strong) PFProfile *profile;
@property(nonatomic, strong) PFAvatar *avatar;
@property(nonatomic, strong) PFCover *cover;
@property(nonatomic, strong) PFStatus *status;

+ (NSString *)endPointFacebook;
+ (NSString *)endPointTwitter;
+ (NSString *)endPointLinkedIn;
+ (NSString *)endPointJoin;
+ (NSString *)endPointLogin;
+ (NSString *)endPointForgotPassword;
+ (NSString *)endPointFeed;
+ (NSString *)endPointSuggested;
+ (NSString *)endPointConnections;
+ (NSString *)endPointWithId;
+ (NSString *)endPointConnect;
+ (NSString *)endPointConnectionAccept;
+ (NSString *)endPointEmailNotification;
+ (NSString *)endPointChangePassword;
+ (NSString *)endPointChangeEmail;

- (NSString *)endPointWithIdPath;
- (NSString *)endPointConnectionsPath;
- (NSString *)endPointConnectPath;
- (NSString *)endPointConnectionAcceptPath;


@end
