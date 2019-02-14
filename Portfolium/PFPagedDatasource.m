//
//  PFPagedDatasource.m
//  Portfolium
//
//  Created by John Eisberg on 6/17/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFPagedDataSource.h"
#import "PFPagedDataSourceDelegate.h"
#import "PFApi.h"

@interface PFPagedDataSource ()

@property(nonatomic, strong) NSMutableArray *indexedData;
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, strong) PFPagedDataSourceDataLoaderBlock dataLoader;

@end

@implementation PFPagedDataSource

+ (PFPagedDataSource *)dataSourceWithPageSize:(NSInteger)pageSize
                                   dataLoader:(PFPagedDataSourceDataLoaderBlock)dataLoader; {
    
    PFPagedDataSource *ds = [[self alloc] init];
    [ds setPageSize:pageSize];
    [ds setDataLoader:dataLoader];
    
    return ds;
}

- (id)init; {
    
    self = [super init];
    if (self) {
        
        [self setState:PFPagedDataSourceStateReady];
        [self setData:[NSMutableArray array]];
        
        indexed = NO;
    }
    
    return self;
}

- (void)load; {
    
    if ([self state] == PFPagedDataSourceStateReady &&
        [[self data] count] == 0) { [self loadNextPage]; }
}

- (void)refresh; {
    
    [[self indexedData] removeAllObjects]; [self setCurrentPage:0];
    
    if ([self state] == PFPagedDataSourceStateReady ||
        [self state] == PFPagedDataSourceStateFullyLoaded ||
        [self state] == PFPagedDataSourceStateEmpty ) {
        
        [self refreshPage];
    }
}

- (id)itemAtIndex:(NSInteger)index; {
    
    if ([self state] == PFPagedDataSourceStateReady &&
        index == ([self currentPage] * [self pageSize]) - [self pageSize]) {
        
        [self loadNextPage];
    }
    
    return [[self data] objectAtIndex:index];
}

- (NSInteger)numberOfItems; {
    
    return [[self data] count];
}

- (void)loadNextPage {
    
    [self setState:PFPagedDataSourceStateLoading];
    
    [self dataLoader]([self currentPage], ^(NSArray *newData) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self doPage:newData];
            
            if ([newData count] > 0 && [[self delegate] respondsToSelector:
                                        @selector(pagedDataSource:didLoadAdditionalItems:)]) {
                
                [[self delegate] pagedDataSource:self
                          didLoadAdditionalItems:[newData count]];
            }
        });
        
    }, ^NSError *(NSError *errorMessage) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setState:PFPagedDataSourceStateReady];
        });
        
        return errorMessage;
    });
}

- (void)refreshPage {
    
    [self setState:PFPagedDataSourceStateLoading];
    
    [self dataLoader]([self currentPage], ^(NSArray *newData) {
        
        [self setCurrentPage:[self currentPage] + 1];
        
        NSInteger numberOfItems = [self numberOfItems];
        
        if(numberOfItems < [newData count]) {
            numberOfItems = [newData count];
        }
        
        NSMutableArray *copy = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < numberOfItems; i++) {
            
            if(i < [newData count]) {
                
                [copy insertObject:[newData objectAtIndex:i] atIndex:i];
            }
        }
        
        [self setData:copy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([self postProcessBlock]) {
                
                for (id item in newData) {
                    [self postProcessBlock](item);
                }
            }
            
            if ([newData count] < [self pageSize]) {
                
                if ([[self data] count] == 0) {
                    [self setState:PFPagedDataSourceStateEmpty];
                } else {
                    [self setState:PFPagedDataSourceStateFullyLoaded];
                }
                
            } else {
                [self setState:PFPagedDataSourceStateReady];
            }
            
            if ([newData count] > 0 && [[self delegate] respondsToSelector:
                                        @selector(pagedDataSource:didRefreshItems:)]) {
                
                [[self delegate] pagedDataSource:self didRefreshItems:[newData count]];
            }
        });
        
    }, ^NSError *(NSError *errorMessage) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setState:PFPagedDataSourceStateReady];
        });
        
        return errorMessage;
    });
}

- (void)doPage:(NSArray *)newData; {
    
    [self setCurrentPage:[self currentPage] + 1];
    [[self data] addObjectsFromArray:newData];
    
    if ([self postProcessBlock]) {
        
        for (id item in newData) {
            [self postProcessBlock](item);
        }
    }
    
    if ([newData count] < [self pageSize]) {
        
        if ([[self data] count] == 0) {
            [self setState:PFPagedDataSourceStateEmpty];
        } else {
            [self setState:PFPagedDataSourceStateFullyLoaded];
        }
        
    } else {
        [self setState:PFPagedDataSourceStateReady];
    }
}

- (void)setState:(PFPagedDataSourceState)state; {
    
    PFPagedDataSourceState oldState = _state;
    _state = state;
    
    if ([[self delegate] respondsToSelector:
         @selector(pagedDataSource:didTransitionFromState:toState:)]) {
        
        [[self delegate] pagedDataSource:self
                  didTransitionFromState:oldState
                                 toState:state];
    }
}

- (id)itemAtIndex:(NSInteger)index forSection:(NSUInteger)section {
    
    return [[_indexedData objectAtIndex:section] objectAtIndex:index];
}

- (NSInteger)numberOfItemsForSection:(NSUInteger)section {
    
    return [(NSArray *)[_indexedData objectAtIndex:section] count];
}

- (NSInteger)numberOfSections {
    
    return [_indexedData count];
}

- (BOOL)isEmpty; {
    
    return [[self data] count] == 0;
}

@end
