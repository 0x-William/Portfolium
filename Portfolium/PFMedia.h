//
//  PFMedia.h
//  Portfolium
//
//  Created by John Eisberg on 8/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"
#import "PFFilename.h"

@interface PFMedia : NSObject<PFModel>

@property(nonatomic, strong) NSString *createdAt;
@property(nonatomic, strong) NSNumber *dfault;
@property(nonatomic, strong) NSNumber *deleted;
@property(nonatomic, strong) NSNumber *entryId;
@property(nonatomic, strong) NSNumber *height;
@property(nonatomic, strong) NSNumber *mediaId;
@property(nonatomic, strong) NSDate *updatedAt;
@property(nonatomic, strong) NSNumber *video;
@property(nonatomic, strong) NSNumber *width;
@property(nonatomic, strong) PFFilename *filename;

+ (NSString *)endPointWithId;

- (NSString *)endPointWithIdPath;

@end