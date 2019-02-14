//
//  PFIAmAVC.m
//  Portfolium
//
//  Created by John Eisberg on 7/30/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFIAmAVC.h"
#import "PFColor.h"
#import "PFOBEducationVC.h"
#import "UIViewController+PFExtensions.h"
#import "UITableView+PFExtensions.h"
#import "PFFont.h"
#import "PFSize.h"

static NSString *kCellIdentifier = @"PFIAmAVCCell";

NSString *const kHighSchool = @"High School Student";
NSString *const kCommunityCollege = @"Community College Student";
NSString *const kUndergrad = @"Undergraduate Student";
NSString *const kGradStudent = @"Graduate Student";
NSString *const kAlumni = @"Alumni";
NSString *const kPortfolium = @"I just want a Portfolium";

@interface PFIAmAVC ()

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, weak) PFOBEducationVC *delegate;

@end

@implementation PFIAmAVC

+ (PFIAmAVC *)_new:(PFOBEducationVC *)delegate; {
    
    PFIAmAVC *vc = [[PFIAmAVC alloc] initWithNibName:nil bundle:nil];
    [vc setDelegate:delegate]; return vc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setDataSource:@[NSLocalizedString(kHighSchool, nil),
                              NSLocalizedString(kCommunityCollege, nil),
                              NSLocalizedString(kUndergrad, nil),
                              NSLocalizedString(kGradStudent, nil),
                              NSLocalizedString(kAlumni, nil),
                              NSLocalizedString(kPortfolium, nil)]];
    }
    
    return self;
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setUpImageBackButton];
    [self setTitle:NSLocalizedString(@"I am currently a(n):", nil)];
    [[self view] setBackgroundColor:[PFColor lightGrayColor]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:
                              CGRectMake(0, 0, [PFSize screenWidth], 64 + (44 * [[self dataSource] count]))];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setScrollEnabled:NO];
    [tableView setSeparatorColor:[PFColor lightGrayColor]];
    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:kCellIdentifier];
    [[self view] addSubview:tableView];
    [self setTableView:tableView];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [[self tableView] setSeparatorInsetZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return [[self dataSource] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kCellIdentifier];
    }
    
    if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    cell.textLabel.text = [[self dataSource] objectAtIndex:[indexPath row]];
    cell.textLabel.textColor = [PFColor textFieldTextColor];
    cell.textLabel.font = [PFFont fontOfLargeSize];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [[self delegate] didChooseWhoIAm:[[self dataSource] objectAtIndex:[indexPath row]]];
    [[self navigationController] popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section; {
    
    return 0.01f;
}

@end
