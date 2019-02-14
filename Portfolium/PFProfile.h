//
//  PFProfile.h
//  Portfolium
//
//  Created by John Eisberg on 8/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"

@class PFAvatar;
@class PFStatus;

@interface PFProfile : NSObject<PFModel>

@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, strong) NSString *firstname;
@property(nonatomic, strong) NSString *lastname;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *school;
@property(nonatomic, strong) NSString *major;
@property(nonatomic, strong) NSNumber *connected;
@property(nonatomic, strong) PFAvatar *avatar;
@property(nonatomic, strong) PFStatus *status;

+ (NSString *)endPointSearch;

@end