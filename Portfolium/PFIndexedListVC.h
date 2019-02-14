//
//  PFIndexedListVC.h
//  Portfolium
//
//  Created by John Eisberg on 9/3/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFIndexable.h"

@interface PFIndexedListVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableDictionary *sections;
@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, strong) NSMutableArray *filtered;
@property(nonatomic, assign) BOOL isFiltered;
@property(nonatomic, assign) BOOL isFiltering;

- (id<PFIndexable>)indexableAtIndexPath:(NSIndexPath *)indexPath;

- (void)buildSections;

- (void)doFilter:(NSString *)searchText;

@end
