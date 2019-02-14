//
//  PFSearchResultsVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/19/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFSearchResultsVC.h"
#import "PFSearchTypeVC.h"
#import "PFRootViewController.h"
#import "PFSearchResultsView.h"
#import "PFContentView.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFColor.h"
#import "UIViewController+PFExtensions.h"
#import "PFNetworkViewItem.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "NSString+PFExtensions.h"
#import "PFApi.h"
#import "PFErrorHandler.h"
#import "PFImage.h"
#import "PFStatus.h"
#import "PFNavigationController.h"
#import "PFProfileVC.h"
#import "PFGoogleAnalytics.h"
#import "PFSize.h"

@interface PFSearchResultsVC ()

@property(nonatomic, strong) NSString *q;
@property(nonatomic, strong) PFSearchTypeVC *entriesVC;
@property(nonatomic, strong) PFSearchTypeVC *peopleVC;
@property(nonatomic, assign) PFViewControllerState state;
@property(nonatomic, weak) PFSearchTypeVC *activeVC;
@property(nonatomic, strong) PFErrorHandlerBlock errorBlock;
@property(nonatomic, strong) UIView *shim;
@property(nonatomic, assign) BOOL shimmed;

@end

@implementation PFSearchResultsVC

@synthesize shimmed = _shimmed;

+ (PFSearchResultsVC *)_new:(NSString *)q; {
    
    PFSearchResultsVC *vc = [[PFSearchResultsVC alloc] initWithNibName:nil bundle:nil q:q];
    [vc setQ:q];
    
    return vc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
               q:(NSString *)q; {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setEntriesVC:[PFSearchTypeVC _entries:self q:q]];
        [self setPeopleVC:[PFSearchTypeVC _people:self q:q]];

        [[self entriesVC] view];
        [[self peopleVC] view];
        
        @weakify(self)
        
        [self setErrorBlock:^NSError *(NSError *error) {
            
            @strongify(self)
            
            [[PFErrorHandler shared] showInErrorBar:error
                                           delegate:nil
                                             inView:[self view]
                                             header:PFHeaderHiding];
            return error;
        }];
    }
    
    return self;
}

- (void)loadView; {
    
    PFSearchResultsView *view = [[PFSearchResultsView alloc]
                                 initWithFrame:CGRectZero delegate:self];
    
    [view setBackgroundColor:[PFColor lightGrayColor]];
    
    [self setView:view];
}

- (void)viewDidLoad; {
    
    [self setTitle:[self q]];
    
    [super viewDidLoad];
    
    UIView *shim = [[UIView alloc] initWithFrame:
                    CGRectMake(0, 0, [PFSize screenWidth], [self applicationFrameOffset])];

    [shim setBackgroundColor:[UIColor whiteColor]];
    [shim setAlpha:0.8];
    [shim setHidden:YES];
    [[self view] addSubview:shim];
    [self setShim:shim];
    
    [self setUpImageBackButtonBlack];
}

- (void)viewWillAppear:(BOOL)animated; {
    [super viewWillAppear:animated];
    
    [[[self navigationController] navigationBar] restyleNavigationBarTranslucentWhite];
    
    if([self state] == PFViewControllerLaunching) {
        
        [self entriesButtonAction:nil];
        [self setState:PFViewControllerReady];
    }
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kSearchResultsPage];
}

- (void)entriesButtonAction:(UIButton *)button; {
    [self layoutVC:[self entriesVC]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[self entriesVC] entriesButton] setSelected:YES];
        [[[self entriesVC] connectionsButton] setSelected:NO];
    });
}

- (void)peopleButtonAction:(UIButton *)button; {
    [self layoutVC:[self peopleVC]];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[[self peopleVC] entriesButton] setSelected:NO];
        [[[self peopleVC] connectionsButton] setSelected:YES];
    });
}

- (void)layoutVC:(PFSearchTypeVC *)vc; {
    
    PFContentView *view = (PFContentView *)[vc view];
    [[self contentView] setContentView:view];
    [self setActiveVC:vc];
    
    [self viewDidLayout];
}

- (void)viewDidLayout; {
    
    [[self activeVC] viewWillAppear:YES];
}

- (void)showShim; {
    
    [[self shim] setHidden:NO];
}

- (void)hideShim; {
    
    [[self shim] setHidden:YES];
}

- (BOOL)shimmed; {
    
    return _shimmed;
}

- (void)setShimmed:(BOOL)shimmed; {
    
    _shimmed = shimmed;
}

- (void)pushUserProfile:(NSNumber *)userId; {
    
    [[self rootNavigationController] pushViewController:[PFProfileVC _new:userId]
                                               animated:YES
                                                   shim:self];
}

- (PFNavigationController *)rootNavigationController; {
    
    return (PFNavigationController *)[self navigationController];
}

- (PFSearchResultsView *)contentView; {
    
    return (PFSearchResultsView *)[self view];
}

@end
