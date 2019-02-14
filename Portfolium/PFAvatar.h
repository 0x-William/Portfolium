//
//  PFAvatar.h
//  Portfolium
//
//  Created by John Eisberg on 8/10/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"

@interface PFAvatar : NSObject<PFModel>

@property(nonatomic, strong) NSString *dynamic;
@property(nonatomic, strong) NSString *dynamicHttps;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *urlHttps;

+ (NSString *)endPointCreate;

@end