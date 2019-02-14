//
//  PFMessage.h
//  Portfolium
//
//  Created by John Eisberg on 8/11/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"
#import "PFProfile.h"

@interface PFMessage : NSObject<PFModel>

@property(nonatomic, strong) NSNumber *messageId;
@property(nonatomic, strong) NSNumber *threadId;
@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, strong) NSString *body;
@property(nonatomic, strong) NSString *createdAt;
@property(nonatomic, strong) NSDate *readAt;
@property(nonatomic, strong) PFProfile *profile;

@end