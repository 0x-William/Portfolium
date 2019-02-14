//
//  PFInterestsVC.m
//  Portfolium
//
//  Created by John Eisberg on 10/5/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFInterestsVC.h"
#import "PFContentView.h"
#import "PFBarButtonContainer.h"
#import "PFCategoriesViewItem.h"
#import "PFColor.h"
#import "UIViewController+PFExtensions.h"
#import "PFApi.h"
#import "PFErrorHandler.h"
#import "PFOnboarding.h"
#import "PFHomeVC.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFGoogleAnalytics.h"

@interface PFInterestsVC ()

@end

@implementation PFInterestsVC

+ (PFInterestsVC *)_new; {
    
    PFInterestsVC *vc = [[PFInterestsVC alloc] initWithNibName:nil bundle:nil];
    [vc setHeaderString:NSLocalizedString(@"Add or remove the categories you're interested in", nil)];

    @weakify(vc)
    
    [vc setErrorBlock:^NSError *(NSError *error) {
        
        @strongify(vc)
        
        [[PFErrorHandler shared] showInErrorBar:error
                                       delegate:nil
                                         inView:[vc view]
                                         header:PFHeaderOpaque];
        return error;
    }];
    
    return vc;
}

- (void)loadView; {
    
    [super loadViewWithContentOffset:0.0f];
    
    [[[PFOnboarding shared] categories] removeAllObjects];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Interests", nil)];
    
    @weakify(self)
    
    UIView *rightBarButtonContainer = [PFBarButtonContainer done:^(id sender) {
        
        @strongify(self)
        
        [[PFApi shared] postUserInterests:[[PFOnboarding shared] categories]
                                  success:^{
                                      
                                      [[PFHomeVC shared] dismissGridButtonAction];
                                      
                                  } failure:^NSError *(NSError *error) {
                                      
                                      [[PFErrorHandler shared] showInErrorBar:error
                                                                     delegate:nil
                                                                       inView:[self view]
                                                                       header:PFHeaderOpaque];
                                      return error;
                                  }];
    }];
    
    [self setRightBarButtonContainer:rightBarButtonContainer];
    
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc]
                                                  initWithCustomView:[self rightBarButtonContainer]]];
    [self setUpImageDismissButton];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [[PFGoogleAnalytics shared] track:kInterestsPage];
}

- (void)categoriesWereUpdated; {
}

- (UIButton *)doneButton; {
    
    return [[[self rightBarButtonContainer] subviews] objectAtIndex:0];
}

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

@end
