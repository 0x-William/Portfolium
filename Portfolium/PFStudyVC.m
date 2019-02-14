//
//  PFStudyVC.m
//  Portfolium
//
//  Created by John Eisberg on 7/30/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFStudyVC.h"
#import "PFContentView.h"
#import "PFColor.h"
#import "PFApi.h"
#import "PFActivityIndicatorView.h"
#import "PFSchool.h"
#import "PFIAmAVC.h"
#import "PFOBEducationVC.h"
#import "PFMajor.h"
#import "UIViewController+PFExtensions.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFSize.h"

static NSString *kCellIdentifier = @"PFStudyVCCell";

@interface PFStudyVC ()

@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, weak) NSString *whoAmI;
@property(nonatomic, weak) PFOBEducationVC *delegate;

@end

@implementation PFStudyVC

+ (PFStudyVC *)_new:(PFOBEducationVC *)delegate; {
    
    PFStudyVC *vc = [[PFStudyVC alloc] initWithNibName:nil bundle:nil];
    [vc setDelegate:delegate]; return vc;
}

- (void)loadView; {
    
    PFContentView *view = [[PFContentView alloc] initWithFrame:CGRectZero];
    [view setContentOffset:-14.0f];
    
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
    [[self view] setBackgroundColor:[PFColor lightGrayColor]];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:
                              CGRectMake(0, 0, [PFSize screenWidth], 44)];
    
    [searchBar setDelegate:self];
    [searchBar setUserInteractionEnabled:NO];
    [[self navigationItem] setTitleView:searchBar];
    
    [[[self studyView] spinner] startAnimating];
    
    @weakify(self)
    
    void (^success)(NSArray *);
    success = ^(NSArray *data) {
        
        @strongify(self)
        
        [self setDataSource:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[[self studyView] spinner] stopAnimating];
            
            [[self tableView] reloadData];
            [[self tableView] setSeparatorColor:[PFColor separatorColor]];
            
            [self buildSections];
            [[self tableView] reloadData];
            
            [searchBar setUserInteractionEnabled:YES];
        });
    };
    
    NSError* (^failure)(NSError *);
    failure = ^(NSError *error) {
        
        @strongify(self)
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[self studyView] spinner] stopAnimating];
        });
        
        return error;
    };
    
    [[PFApi shared] majors:^(NSArray *data) {
        success(data);
    } failure:^NSError *(NSError *error) {
        return failure(error);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFMajor *major = (PFMajor *)[self indexableAtIndexPath:indexPath];
    
    [[self delegate] didChooseFieldOfStudy:[major name]];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText; {
    
    if(![self isFiltering]) {
        [super doFilter:searchText];
    }
}

- (PFContentView *)studyView; {
    
    return (PFContentView *)[self view];
}

@end
