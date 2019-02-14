//
//  PFToken.h
//  Portfolium
//
//  Created by John Eisberg on 6/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PFModel.h"

@class RKObjectMapping;

@interface PFToken : NSObject<PFModel>

@property(nonatomic, strong) NSString *token;
@property(nonatomic, strong) NSNumber *source;
@property(nonatomic, strong) NSNumber *tokenId;
@property(nonatomic, strong) NSNumber *fkUserId;
@property(nonatomic, strong) NSNumber *fkKeyId;
@property(nonatomic, strong) NSDate *createdAt;

@end
