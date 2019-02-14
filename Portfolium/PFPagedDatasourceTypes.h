//
//  PFPagedDatasourceTypes.h
//  Portfolium
//
//  Created by John Eisberg on 6/17/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFApiTypes.h"

static const NSInteger kDefaultPageSize = 16;

typedef enum {
    
    PFPagedDataSourceStateReady,
    PFPagedDataSourceStateLoading,
    PFPagedDataSourceStateReloading,
    PFPagedDataSourceStateEmpty,
    PFPagedDataSourceStateFullyLoaded
}   PFPagedDataSourceState;

typedef void (^PFPagedDataSourceDataLoaderBlock)(NSInteger pageNumber,
                                                 PFApiFeedSuccessBlock successBlock,
                                                 PFApiErrorHandlerBlock failure);

typedef void (^PFPagedDataSourcePostProcessBlock)(id item);