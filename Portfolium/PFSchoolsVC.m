//
//  PFSchoolsVC.m
//  Portfolium
//
//  Created by John Eisberg on 7/30/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFSchoolsVC.h"
#import "PFContentView.h"
#import "PFColor.h"
#import "PFApi.h"
#import "PFActivityIndicatorView.h"
#import "PFSchool.h"
#import "PFIAmAVC.h"
#import "PFOBEducationVC.h"
#import "UIViewController+PFExtensions.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFClassification.h"
#import "PFSize.h"

static NSString *kCellIdentifier = @"PFSchoolsVCCell";

@interface PFSchoolsVC ()

@property(nonatomic, weak) NSString *whoAmI;
@property(nonatomic, weak) PFOBEducationVC *delegate;

@end

@implementation PFSchoolsVC

+ (PFSchoolsVC *)_new:(NSString *)whoAmI delegate:(PFOBEducationVC *)delegate; {
    
    PFSchoolsVC *vc = [[PFSchoolsVC alloc] initWithNibName:nil bundle:nil];
    
    [vc setWhoAmI:whoAmI];
    [vc setDelegate:delegate];
    
    return vc;
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
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:
                              CGRectMake(0, 0, [PFSize screenWidth], 44)];
    
    [searchBar setDelegate:self];
    [searchBar setUserInteractionEnabled:NO];
    [[self navigationItem] setTitleView:searchBar];
    
    [[self view] setBackgroundColor:[PFColor lightGrayColor]];
    
    [[[self schoolView] spinner] startAnimating];
    
    @weakify(self)
    
    void (^success)(NSArray *);
    success = ^(NSArray *data) {
        
        @strongify(self)
        
        [self setDataSource:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[[self schoolView] spinner] stopAnimating];
            
            [[self tableView] reloadData];
            [[self tableView] setSeparatorColor:[PFColor lightGrayColor]];
            
            [self buildSections];
            [[self tableView] reloadData];
            
            [searchBar setUserInteractionEnabled:YES];
        });
    };
    
    NSError* (^failure)(NSError *);
    failure = ^(NSError *error) {
        
        @strongify(self)
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[self schoolView] spinner] stopAnimating];
        });
        
        return error;
    };
    
    if([[self whoAmI] isEqualToString:kHighSchoolTypeReadable]) {
     
        [[PFApi shared] highSchools:^(NSArray *data) {
            success(data);
        } failure:^NSError *(NSError *error) {
            return failure(error);
        }];
    
    } else if([[self whoAmI] isEqualToString:kUndergradTypeReadable]) {
        
        [[PFApi shared] colleges:^(NSArray *data) {
            success(data);
        } failure:^NSError *(NSError *error) {
            return failure(error);
        }];
    
    } else if([[self whoAmI] isEqualToString:kGradStudentTypeReadable]) {
        
        [[PFApi shared] colleges:^(NSArray *data) {
            success(data);
        } failure:^NSError *(NSError *error) {
            return failure(error);
        }];
    
    } else if([[self whoAmI] isEqualToString:kCommunityCollegeTypeReadable]) {
        
        [[PFApi shared] communityColleges:^(NSArray *data) {
            success(data);
        } failure:^NSError *(NSError *error) {
            return failure(error);
        }];
    
    } else if([[self whoAmI] isEqualToString:kAlumniTypeReadable]) {
        
        [[PFApi shared] colleges:^(NSArray *data) {
            success(data);
        } failure:^NSError *(NSError *error) {
            return failure(error);
        }];
        
    } else {
        
        [[PFApi shared] colleges:^(NSArray *data) {
            success(data);
        } failure:^NSError *(NSError *error) {
            return failure(error);
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFSchool *school = (PFSchool *)[self indexableAtIndexPath:indexPath];

    [[self delegate] didChooseSchool:[school name]];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText; {
    
    if(![self isFiltering]) {
        [super doFilter:searchText];
    }
}

- (PFContentView *)schoolView; {
    
    return (PFContentView *)[self view];
}

@end
