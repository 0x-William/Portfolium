//
//  PFAccomplishment.h
//  Portfolium
//
//  Created by John Eisberg on 11/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFFilename.h"
#import "PFModel.h"

@interface PFAccomplishment : NSObject<PFModel>

@property(nonatomic, strong) NSNumber *accomplishmentId;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *descr;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) PFFilename *image;
@property(nonatomic, strong) NSDate *createdAt;
@property(nonatomic, strong) NSDate *updatedAt;

@end