//
//  PFSubCategoriesVC.m
//  Portfolium
//
//  Created by John Eisberg on 11/16/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFSubCategoriesVC.h"
#import "PFAddEntryVC.h"
#import "PFContentView.h"
#import "UIViewController+PFExtensions.h"
#import "PFColor.h"
#import "PFActivityIndicatorView.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFSystemCategory.h"
#import "PFApi.h"
#import "PFSize.h"

static NSString *kCellIdentifier = @"PFSubCategoriesVCCell";

@interface PFSubCategoriesVC ()

@property(nonatomic, weak) PFAddEntryVC *delegate;

@end

@implementation PFSubCategoriesVC

+ (PFSubCategoriesVC *)_new:(PFAddEntryVC *)delegate; {
    
    PFSubCategoriesVC *vc = [[PFSubCategoriesVC alloc] initWithNibName:nil bundle:nil];
    [vc setDelegate:delegate];
    
    return vc;
}

- (void)loadView; {
    
    PFContentView *view = [[PFContentView alloc] initWithFrame:CGRectZero];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorColor:[UIColor clearColor]];
    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:kCellIdentifier];
    [view setContentView:tableView];
    [self setTableView:tableView];
    
    [self setView:view];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setUpImageBackButton];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:
                              CGRectMake(0, 0, [PFSize screenWidth], 44)];
    
    [searchBar setDelegate:self];
    [searchBar setUserInteractionEnabled:NO];
    [[self navigationItem] setTitleView:searchBar];
    
    [[self view] setBackgroundColor:[PFColor lightGrayColor]];
    
    [[[self contentView] spinner] startAnimating];
    
    @weakify(self)
    
    [[PFApi shared] systemSubCategories:^(NSArray *data) {
        
        @strongify(self)
        
        [self setDataSource:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[[self contentView] spinner] stopAnimating];
            
            [[self tableView] reloadData];
            [[self tableView] setSeparatorColor:[PFColor separatorColor]];
            
            [self buildSections];
            [[self tableView] reloadData];
            
            [searchBar setUserInteractionEnabled:YES];
        });
        
    } failure:^NSError *(NSError *error) {
        
        @strongify(self)
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[self contentView] spinner] stopAnimating];
        });
        
        return error;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFSystemCategory *category = (PFSystemCategory *)[self indexableAtIndexPath:indexPath];

    [[self delegate] setSubCategory:category];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText; {
    
    if(![self isFiltering]) {
        [super doFilter:searchText];
    }
}

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

@end
