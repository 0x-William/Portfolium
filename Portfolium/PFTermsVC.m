//
//  PFTermsVC.m
//  Portfolium
//
//  Created by John Eisberg on 10/4/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFTermsVC.h"
#import "PFCView.h"
#import "PFTermsViewCell.h"
#import "PFColor.h"
#import "UIViewController+PFExtensions.h"
#import "PFBarButtonContainer.h"
#import "PFImage.h"
#import "UIViewController+PFExtensions.h"
#import "PFGoogleAnalytics.h"

@interface PFTermsVC ()

@property(nonatomic, strong) NSString *terms;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) NSString *header;
@property(nonatomic, assign) PFTermsType type;

@end

@implementation PFTermsVC

+ (PFTermsVC *)_new:(PFTermsType)type; {
    
    PFTermsVC *vc = [[PFTermsVC alloc] initWithNibName:nil bundle:nil];
    
    if(type == PFTermsTypeTerms) {
        
        [vc setTerms:NSLocalizedString(@"terms", @"")];
        [vc setTitle:NSLocalizedString(@"Terms of Service", @"")];
        [vc setHeader:NSLocalizedString(@"Terms of Service", @"")];
        
    } else {
        
        [vc setTerms:NSLocalizedString(@"privacy", @"")];
        [vc setTitle:NSLocalizedString(@"Privacy Policy", @"")];
        [vc setHeader:NSLocalizedString(@"Privacy Policy", @"")];
    }
    
    [vc setType:type];
    
    return vc;
}

- (void)loadView; {
    
    PFCView *view = [[PFCView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[PFColor lightGrayColor]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView registerClass:[PFTermsViewCell class]
      forCellReuseIdentifier:[PFTermsViewCell preferredReuseIdentifier]];
    [tableView setBackgroundColor:[PFColor lightGrayColor]];
    [tableView setSeparatorColor:[UIColor clearColor]];
    [view setContentView:tableView];
    [self setTableView:tableView];
    
    [self setView:view];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setUpImageDismissButton];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    if([self type] == PFTermsTypeTerms) {
        [[PFGoogleAnalytics shared] track:kTermsPage];
    } else {
        [[PFGoogleAnalytics shared] track:kPrivacyPage];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFTermsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                [PFTermsViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = [[PFTermsViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:[PFTermsViewCell preferredReuseIdentifier]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    [cell setHeader:[self header]];
    [cell setTerms:[self terms]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    return [PFTermsViewCell heightForTermsLabel:[self terms]] + 40;
}

- (void)popCurrentViewController; {
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
