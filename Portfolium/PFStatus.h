//
//  PFStatus.h
//  Portfolium
//
//  Created by John Eisberg on 10/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"

extern NSString *kConnect;
extern NSString *kPending;
extern NSString *kConnected;
extern NSString *kAccept;

@interface PFStatus : NSObject<PFModel>

@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *token;

@end
