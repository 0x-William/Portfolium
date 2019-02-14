//
//  PFPagedDatasourceDelegate.h
//  Portfolium
//
//  Created by John Eisberg on 6/17/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFPagedDataSourceTypes.h"

@class PFPagedDataSource;

@protocol PFPagedDataSourceDelegate <NSObject>

@optional

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
 didLoadAdditionalItems:(NSInteger)items;

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
 didTransitionFromState:(PFPagedDataSourceState)fromState
                toState:(PFPagedDataSourceState)toState;

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
        didRefreshItems:(NSInteger)items;

@end
