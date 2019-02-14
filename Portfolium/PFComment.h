//
//  PFComment.h
//  Portfolium
//
//  Created by John Eisberg on 8/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"
#import "PFProfile.h"

@interface PFComment : NSObject<PFModel>

@property(nonatomic, strong) NSString *comment;
@property(nonatomic, strong) NSNumber *entryId;
@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, strong) NSNumber *commentId;
//@property(nonatomic, strong) NSString *createdAt;
//@property(nonatomic, strong) NSString *updatedAt;
@property(nonatomic, strong) NSDate *createdAt;
@property(nonatomic, strong) NSDate *updatedAt;
@property(nonatomic, strong) PFProfile *profile;

+ (NSString *)endPointWithEntryId;
+ (NSString *)endPointCreateWithEntryId;

- (NSString *)endPointWithEntryIdPath;
- (NSString *)endPointCreateWithEntryIdPath;

@end