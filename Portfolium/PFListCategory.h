//
//  PFListCategory.h
//  Portfolium
//
//  Created by John Eisberg on 11/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFFilename.h"
#import "PFModel.h"

@interface PFListCategory : NSObject<PFModel>

@property(nonatomic, strong) NSNumber *listCategoryId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *slug;
@property(nonatomic, strong) NSNumber *parentId;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) NSDate *createdAt;
@property(nonatomic, strong) NSString *parentSlug;
@property(nonatomic, strong) NSNumber *interested;
@property(nonatomic, strong) PFFilename *image;
@property(nonatomic, strong) PFFilename *gradient;
@property(nonatomic, strong) PFFilename *hero;
@property(nonatomic, strong) NSArray *tags;

@end