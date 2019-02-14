//
//  PFSystemCategory.h
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFModel.h"
#import "PFIndexable.h"

@class PFImg;
@class PFGradient;

@interface PFSystemCategory : NSObject<PFModel, PFIndexable>

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) NSDate *createdAt;
@property(nonatomic, strong) NSNumber *categoryId;
@property(nonatomic, strong) NSString *parentId;
@property(nonatomic, strong) NSNumber *interested;
@property(nonatomic, strong) NSString *hex;
@property(nonatomic, strong) PFImg *image;
@property(nonatomic, strong) PFGradient *gradient;

+ (NSString *)endPointFeed;
+ (NSString *)endPointWithCategoryId;

- (NSString *)endPointWithCategoryIdPath;

@end
