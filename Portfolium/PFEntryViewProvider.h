//
//  PFEntryViewProvider.h
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFEntryViewDelegate.h"
#import "PFEntryContainer.h"

@class PFPagedDataSource;

typedef void(^PFEntryForItemAtIndexPathBlock)(id<PFEntryContainer> item,
                                              NSIndexPath *indexPath,
                                              PFPagedDataSource *dataSource,
                                              id<PFEntryViewDelegate> delegate);

typedef CGSize (^PFSizeForItemAtIndexPathBlock)(NSIndexPath *indexPath,
                                                PFPagedDataSource *dataSource);

@interface PFEntryViewProvider : NSObject

+ (PFEntryViewProvider *)shared;

@property(nonatomic, strong) PFEntryForItemAtIndexPathBlock entryForItemAtIndexPathBlock;
@property(nonatomic, strong) PFSizeForItemAtIndexPathBlock sizeForItemAtIndexPathBlock;

@end