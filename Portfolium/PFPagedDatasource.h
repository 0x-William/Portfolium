//
//  PFPagedDatasource.h
//  Portfolium
//
//  Created by John Eisberg on 6/17/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFPagedDataSourceTypes.h"

@protocol PFPagedDataSourceDelegate;

@interface PFPagedDataSource : NSObject {
    
@private BOOL indexed;
    
}

@property(nonatomic, strong) NSMutableArray *data;
@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, weak) id<PFPagedDataSourceDelegate> delegate;
@property(nonatomic, assign, readonly) PFPagedDataSourceState state;
@property(nonatomic, strong) PFPagedDataSourcePostProcessBlock postProcessBlock;

+ (PFPagedDataSource *)dataSourceWithPageSize:(NSInteger)pageSize
                                   dataLoader:(PFPagedDataSourceDataLoaderBlock)dataLoader;
- (void)load;
- (void)refresh;

- (NSInteger)numberOfItems;

- (id)itemAtIndex:(NSInteger)index;
- (id)itemAtIndex:(NSInteger)index forSection:(NSUInteger)section;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsForSection:(NSUInteger)section;

- (void)setState:(PFPagedDataSourceState)state;
- (void)loadNextPage;

- (BOOL)isEmpty;

@end
